//
//  LWMultipyBeInvitedViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyBeInvitedViewController.h"

@interface LWMultipyBeInvitedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end

@implementation LWMultipyBeInvitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.walletNameLabel.text = self.contentModel.name;
    NSString *laguage = [NSBundle getCusLanguage];

    [self.joinBtn setTitle:kLocalizable(@"wallet_detail_join") forState:UIControlStateNormal];
    
    for (NSInteger i = 0; i<self.contentModel.parties.count; i++) {
        LWPartiesModel *model = self.contentModel.parties[i];
        if ([model.uid isEqualToString:self.contentModel.uid]) {
            if ([laguage isEqualToString:@"zh-Hans"]) {
                self.label1.text =[NSString stringWithFormat:@" %@ 邀请你加入一个共同管理资金账户. ",model.user];
            }else if ([laguage isEqualToString:@"ja"]){
                self.label1.text =[NSString stringWithFormat:@"%@ のオーナーより、同アカウントへの参加リクエストが届いています。 ",model.user];

            } else{
                self.label1.text =[NSString stringWithFormat:@"You’ve been invited to join this account owned by %@. ",model.user];
            }
            break;
        }
    }
    
    if ([laguage isEqualToString:@"zh-Hans"]) {
         //
         self.labelTwo.text =[NSString stringWithFormat:@"加入之后，需要和其他%ld人共同管理账户.",(long)self.contentModel.parties.count];;
    }else if ([laguage isEqualToString:@"ja"]){
        self.labelTwo.text =[NSString stringWithFormat:@"参加を承認しますと「キー共有メンバー」として他%ld名のメンバーとともにトランザクションを行います。",(long)self.contentModel.parties.count];;

    }else{
         self.labelTwo.text =[NSString stringWithFormat:@"If you accept you’ll be a Key Share Member along with %ld others to assist in signing transactions.",(long)self.contentModel.parties.count];;
     }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinNotification:) name:kWebScoket_multipy_JoinWallet object:nil];
}

- (IBAction)joinclick:(UIButton *)sender {
    
    [SVProgressHUD show];
    NSDictionary *params = @{@"wid":@(self.contentModel.walletId),@"uid":[[LWUserManager shareInstance] getUserModel].uid};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWallet_multipy_JoinWallet),WS_Home_mulpity_JoinWallet,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)joinNotification:(NSNotification *)notification{
     NSDictionary *notiDic = notification.object;
      if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
          [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_detail_joinSuccess")];
          [self requestMulipyWalletInfo];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self.navigationController popViewControllerAnimated:YES];
          });
      }
}

- (void)requestMulipyWalletInfo{
    NSDictionary *multipyparams = @{@"type":@2};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    });
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
