//
//  LWPersonalWalletEditViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalWalletEditViewController.h"
#import "LWPayMailViewController.h"
#import "LWPaymailModel.h"

@interface LWPersonalWalletEditViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *walletName;
@property (weak, nonatomic) IBOutlet UITextField *paymailTF;
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
    
    self.amountLabel.text = [NSString stringWithFormat:@" %@ BSV | %@",[LWNumberTool formatSSSFloat:self.model.personalBitCount],[LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:self.model.personalBitCount]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renameNotification:) name:kWebScoket_walletReName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSatue:) name:kWebScoket_paymail_queryByWid object:nil];
    [self getCurrentPaymailSatue];
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
    LWPayMailViewController *paymailVC = [[LWPayMailViewController alloc] init];
    paymailVC.model = self.model;
    [self.navigationController pushViewController:paymailVC animated:YES];
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

#pragma mark - rename
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
          [WMHUDUntil showMessageToWindow:@"Account Name Edit Success"];
          [LWPublicManager getPersonalWalletData];
      }
}

#pragma mark - paymail
- (void)getCurrentPaymailSatue{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(self.model.walletId)};
      NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestId_paymail_queryByWid),WS_paymail_queryByWid,[multipyparams jsonStringEncoded]];
      [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)getUserSatue:(NSNotification *)notification{

    NSDictionary *resInfo = notification.object;
     if ([[resInfo objectForKey:@"success"] integerValue] == 1) {
         NSArray *statueArray = [resInfo objectForKey:@"data"];
         for (NSInteger i = 0; i<statueArray.count; i++) {
             LWPaymailModel *model = [LWPaymailModel modelWithDictionary:statueArray[i]];
             if (model.index == 0) {
                 self.paymailTF.text = [NSString stringWithFormat:@"%@@volt.id",model.name];
             }
             
             if (model.main == 1) {
                 self.paymailTF.text = [NSString stringWithFormat:@"%@@volt.id",model.name];
                 break;
             }
         }

     }else{
         NSString *message = [resInfo objectForKey:@"message"];
         if (message && message.length>0) {
             [WMHUDUntil showMessageToWindow:message];
         }
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
