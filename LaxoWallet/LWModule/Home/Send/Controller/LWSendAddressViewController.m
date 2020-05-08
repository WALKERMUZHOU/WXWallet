//
//  LWSendAddressViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSendAddressViewController.h"
#import "LWSendAmountViewController.h"
#import "LWSendHistoryPaymailView.h"
#import "LWTransactionModel.h"
#import "libthresholdsig.h"
#import "LWScanTool.h"

@interface LWSendAddressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIView *historyBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@property (nonatomic, strong) LWSendHistoryPaymailView *historyView;

@end

@implementation LWSendAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sendLabel.text = kLocalizable(@"common_Send");
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    if (kScreenWidth == 320 || (kScreenWidth == 375 && kScreenHeight == 667)) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@131);
        }];
    }
    
    self.historyView = [[LWSendHistoryPaymailView alloc] initWithFrame:self.historyBackView.bounds style:UITableViewStyleGrouped];
    [self.historyBackView addSubview:self.historyView];
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.bottom.right.equalTo(self.historyBackView);
     }];
    self.historyView.block = ^(NSString * _Nonnull selectPaymail) {
        self.addressTF.text = selectPaymail;
    };
    
    if (self.sendAddress && self.sendAddress.length>0) {
        self.addressTF.text = self.sendAddress;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getpaymailToAddress:) name:kWebScoket_paymail_toAddress object:nil];

    
}

- (IBAction)nextClick:(UIButton *)sender {
    if (!self.addressTF.text || self.addressTF.text.length == 0) {

        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_pleaseInputEmail")];
        return;
    }
    
    if ([LWEmailTool isEmail:self.addressTF.text]) {
        [SVProgressHUD show];
        [self paymailToAddress];
        return;
    }
   
    char *address_char = address_to_script([LWAddressTool stringToChar:self.addressTF.text]);
    NSString *address_str = [LWAddressTool charToString:address_char];
    if (!address_str || address_str.length == 0) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_EorrorAddress")];
        return;
    }
    
    LWTransactionModel *model = [[LWTransactionModel alloc] init];
    model.address = self.addressTF.text;
    [self pushToNextVCWith:model];
}

- (IBAction)pasteClick:(UIButton *)sender {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    self.addressTF.text = paste.string;

}

- (IBAction)scanClick:(UIButton *)sender {
    [LWScanTool startScanInTextInputView:^(LWScanModel * _Nonnull result) {
         self.addressTF.text = result.scanResult;
     }];
}

#pragma mark - paymailtoAddress
- (void)paymailToAddress{
    NSDictionary *params = @{@"paymail":self.addressTF.text};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestId_paymail_toAddress),WS_paymail_toAddress,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)getpaymailToAddress:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSString *dataAddress = [notiDic objectForKey:@"data"];
        if (dataAddress && dataAddress.length >0) {
            LWTransactionModel *model = [[LWTransactionModel alloc] init];
            model.payMail = self.addressTF.text;
            model.address = dataAddress;
            [self pushToNextVCWith:model];
        }else{
            [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_EorrorAddress")];
        }
    }
}

- (void)pushToNextVCWith:(LWTransactionModel *)model{
    
    if(model.payMail && model.payMail.length >0 && [LWEmailTool isEmail:model.payMail]){
        [self.historyView addpayMail:model.payMail];
    }
    
    LWSendAmountViewController *amountVC = [[LWSendAmountViewController alloc] init];
    amountVC.model = model;
    amountVC.walletModel = self.walletModel;
    [self.navigationController pushViewController:amountVC animated:YES];
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
