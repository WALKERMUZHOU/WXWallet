//
//  LWPCLoginViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/8.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPCLoginViewController.h"

@interface LWPCLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wantLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;

@end

@implementation LWPCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wantLabel.text = kLocalizable(@"wallet_login_want");
    [self.yesBtn setTitle:kLocalizable(@"wallet_login_yes") forState:UIControlStateNormal];
    [self.noBtn setTitle:kLocalizable(@"wallet_login_no") forState:UIControlStateNormal];

    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pcLogoutSatue:) name:kWebScoket_Login_pcLogOut object:nil];
}
- (IBAction)logoutClick:(UIButton *)sender {
    [SVProgressHUD show];
    [self logoutPCStatue];
}


- (void)logoutPCStatue{
    NSDictionary *params = @{@"device":@"pc"};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestIdWallet_Login_pcLogOut),
                                            WS_Login_pcLogOut,
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)pcLogoutSatue:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    [WMHUDUntil showMessageToWindow:@"PC Logout Success"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (IBAction)returnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
