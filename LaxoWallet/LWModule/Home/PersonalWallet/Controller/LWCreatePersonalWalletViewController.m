//
//  LWCreatePersonalWalletViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWCreatePersonalWalletViewController.h"

@interface LWCreatePersonalWalletViewController ()

@property (weak, nonatomic) IBOutlet UITextField *walletNameTF;


@end

@implementation LWCreatePersonalWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multipyWalletCreate:) name:kWebScoket_CreatePersonalWallet object:nil];

}

- (IBAction)completeClick:(UIButton *)sender {
    if (self.walletNameTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"please input account name"];
        return;
    }

    [SVProgressHUD show];

    NSDictionary *params = @{@"name":self.walletNameTF.text,
                                 @"uid":[[LWUserManager shareInstance]getUserModel].uid,
                                };
        
    NSArray *requetCurrentPriceArray = @[@"req",
                                             @(WSRequestIdWallet_CreatePersonalWallet),
                                             WS_Home_wallet_createPersonalWallet,
                                             [params jsonStringEncoded]];
        
    [[SocketRocketUtility instance] sendData:[requetCurrentPriceArray mp_messagePack]];
}

- (void)multipyWalletCreate:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    NSDictionary *resInfo = notification.object;
    if ([[resInfo objectForKey:@"success"] integerValue] == 1) {
        [WMHUDUntil showMessageToWindow:@"account create success"];
        
        [LWPublicManager getPersonalWalletData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

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
