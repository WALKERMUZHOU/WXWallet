//
//  LWPersonalWalletEditViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalWalletEditViewController.h"

@interface LWPersonalWalletEditViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *walletName;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *memberStatueTF;
@property (weak, nonatomic) IBOutlet UITextField *ownerTF;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation LWPersonalWalletEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.walletName.delegate = self;
    self.walletName.tag = 12000;
    self.saveBtn.hidden = YES;
    
    if (self.model.name && self.model.name.length>0) {
        self.walletName.text = self.model.name;
    }
    
    self.timeLabel.text = [LWTimeTool EngLishMonthWithTimeStamp:self.model.createtime abbreviations:YES EnglishShortNameForDate:NO];
    
    self.amountLabel.text = [NSString stringWithFormat:@" %@ BSV | %@",[LWNumberTool formatSSSFloat:self.model.personalBitCount],self.model.personalPrice];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renameNotification:) name:kWebScoket_walletReName object:nil];
    
    // Do any additional setup after loading the view from its nib.
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 12000) {//walletName
        self.saveBtn.hidden = NO;
        return YES;
    }else if (textField.tag == 12001){
        //checkStatue
        return NO;
    }
    return YES;
}

- (IBAction)addPaymailClick:(UIButton *)sender {
    
}

- (IBAction)saveClick:(UIButton *)sender {
    sender.hidden = YES;
    if ([_walletName.text isEqualToString:self.model.name]) {
        return;
    }else{
        if (_walletName.text.length>0) {
            [self resetWalletName];
        }
    }
}

- (void)resetWalletName{
    [SVProgressHUD show];
    NSDictionary *params = @{@"wid":@(self.model.walletId),@"name":self.walletName.text};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWallet_resetWalletName),WS_Home_wallet_rename,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)renameNotification:(NSNotification *)notification{
    [SVProgressHUD dismiss];
     NSDictionary *notiDic = notification.object;
      if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
          if (self.block) {
              self.block(self.walletName.text);
          }
          [WMHUDUntil showMessageToWindow:@"Wallet Name Edit Success"];
          [LWPublicManager getPersonalWalletData];
      }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
