//
//  LWMultipyEditViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyEditViewController.h"
#import "LWMultipyEditMemberViewController.h"
#import "LWPayMailViewController.h"
#import "LWMultipyUserStatueViewController.h"

@interface LWMultipyEditViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *walletName;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *memberStatueTF;
@property (weak, nonatomic) IBOutlet UITextField *ownerTF;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation LWMultipyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.walletName.delegate = self;
    self.memberStatueTF.delegate = self;
    self.saveBtn.hidden = YES;
    
    self.walletName.text = self.model.name;
    
    self.timeLabel.text = [LWTimeTool EngLishMonthWithTimeStamp:self.model.createtime abbreviations:YES EnglishShortNameForDate:NO];
    
    self.amountLabel.text = [NSString stringWithFormat:@" %@ BSV | %@",[LWNumberTool formatSSSFloat:self.model.personalBitCount],[LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:self.model.personalBitCount]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partiesNotification:) name:kWebScoket_messageParties object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renameNotification:) name:kWebScoket_walletReName object:nil];
    [self queryParties];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 12000) {//walletName
        self.saveBtn.hidden = NO;
        return YES;
    }else if (textField.tag == 12001){
        //checkStatue
        LWMultipyUserStatueViewController *userStatueVC = [[LWMultipyUserStatueViewController alloc] init];
        userStatueVC.walletModel = self.model;
        [self.navigationController pushViewController:userStatueVC animated:YES];
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
          [WMHUDUntil showMessageToWindow:@"Account Name Edit Success"];
          [self requestMulipyWalletInfo];
      }
}

- (void)requestMulipyWalletInfo{
    NSDictionary *multipyparams = @{@"type":@2};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    });
}

- (void)queryParties{
    [SVProgressHUD show];
    NSDictionary *params = @{@"wid":@(self.model.walletId)};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQueryMessageParties),WS_Home_MessageParties,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
    
}

- (void)partiesNotification:(NSNotification *)notification{
    [SVProgressHUD dismiss];
     NSDictionary *notiDic = notification.object;
      if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
          NSArray *partiesArray = [notiDic objectForKey:@"data"];
          self.model.parties = [NSArray modelArrayWithClass:[LWPartiesModel class] json:partiesArray];

          for (NSInteger i = 0; i<partiesArray.count; i++) {
              LWPartiesModel *patiesModel = [LWPartiesModel modelWithJSON:partiesArray[i]];
              if ([patiesModel.uid isEqualToString:self.model.uid]) {
                  self.ownerTF.text = patiesModel.user;
                  return;
              }
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
