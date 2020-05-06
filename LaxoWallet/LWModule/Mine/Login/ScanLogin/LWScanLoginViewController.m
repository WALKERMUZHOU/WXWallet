//
//  LWScanLoginViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWScanLoginViewController.h"
#import "libthresholdsig.h"

@interface LWScanLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wantLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@end

@implementation LWScanLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.wantLabel.text = kLocalizable(@"wallet_scan_login_want");
    [self.yesBtn setTitle:kLocalizable(@"wallet_scan_login_yes") forState:UIControlStateNormal];
    self.noLabel.text = kLocalizable(@"wallet_scan_login_no");
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginRes:) name:kWebScoket_scanLogin object:nil];
}
- (IBAction)loginClick:(UIButton *)sender {
    
    char *getSceret = get_shared_secret([LWAddressTool stringToChar:[LWPublicManager getPKWithZhuJiCi]],[LWAddressTool stringToChar:self.scanId]);
      NSString *zhujiciEncrypt = [LWEncryptTool encrywithTheKey:[LWAddressTool charToString:getSceret] message:[[LWUserManager shareInstance] getUserModel].jiZhuCi andHex:1];
    
    NSDictionary *params = @{@"id":self.scanId,@"key":[LWPublicManager getPubKeyWithZhuJiCi],@"seed":zhujiciEncrypt};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestId_Login_scanLogin),
                                            WS_Login_ScanLogin,
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    
    if ([[SocketRocketUtility instance] socketReadyState] == SR_OPEN) {
        [[SocketRocketUtility instance] sendData:data];
        [SVProgressHUD show];
    }else{
        [WMHUDUntil showMessageToWindow:@"Network connecting..."];
    }
    
}
- (void)requestPersonalWalletInfo{
    NSDictionary *params = @{@"type":@1};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestIdWalletQueryPersonalWallet),
                                            @"wallet.query",
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SocketRocketUtility instance] sendData:data];
    });
}

- (IBAction)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginRes:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSLog(@"login_success");
        [self dismissViewControllerAnimated:YES completion:nil];
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
