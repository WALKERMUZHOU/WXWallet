//
//  LWLoginController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginController.h"
#import "LWLoginStepOneView.h"
#import "LWLoginStepTwoView.h"
#import "LWLoginStepThreeView.h"
#import "LWLoginStepFourView.h"
#import "LWLoginStepFiveView.h"
#import "LWLoginCoordinator.h"


#import "libthresholdsig.h"
#import "LWAddressTool.h"

@interface LWLoginController ()
@property (weak, nonatomic) IBOutlet UIView *scrollBackView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) NSString *emailStr;

@end

@implementation LWLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
}


- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.scrollBackView.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.scrollEnabled = NO;
    _scrollView.contentSize= CGSizeMake(kScreenWidth * 5, self.scrollBackView.kheight);
    [self.scrollBackView addSubview:_scrollView];
    
    LWLoginStepOneView *viewOne = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepOneView class]) owner:nil options:nil].lastObject;
    viewOne.frame = CGRectMake(0, 0, kScreenWidth,self.scrollBackView.kheight);
    [self.scrollView addSubview:viewOne];
    viewOne.block = ^{
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    };

    LWLoginStepTwoView *view2 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepTwoView class]) owner:nil options:nil].lastObject;
    view2.frame = CGRectMake(kScreenWidth, 0, kScreenWidth,self.scrollBackView.kheight);
    [self.scrollView addSubview:view2];
    view2.block = ^(NSString * _Nonnull email) {
        [self verifyEmail:email];
    };
//
    LWLoginStepThreeView *view3 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepThreeView class]) owner:nil options:nil].lastObject;
    view3.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth,self.scrollBackView.kheight);
    [self.scrollView addSubview:view3];
    view3.block = ^(NSString * _Nonnull code) {
        [self verifyCode:code];
    };
//
    LWLoginStepFourView *view4 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepFourView class]) owner:nil options:nil].lastObject;
    view4.frame = CGRectMake(kScreenWidth * 3, 0, kScreenWidth,self.scrollBackView.kheight);
    [self.scrollView addSubview:view4];

    LWLoginStepFiveView *view5 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepFiveView class]) owner:nil options:nil].lastObject;
    view5.frame = CGRectMake(kScreenWidth * 4, 0, kScreenWidth,self.scrollBackView.kheight);
    [self.scrollView addSubview:view5];
    
}

#pragma mark - method
- (void)verifyEmail:(NSString *)email{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth *2, 0) animated:YES];
    return;
    [SVProgressHUD show];
     NSString *emailStr = email;
     [LWLoginCoordinator getSMSCodeWithEmail:emailStr WithSuccessBlock:^(id  _Nonnull data) {
         [SVProgressHUD dismiss];
         [WMHUDUntil showMessageToWindow:@"验证码发送成功"];
         [self.scrollView setContentOffset:CGPointMake(kScreenWidth *2, 0) animated:YES];
         self.emailStr = email;
     } WithFailBlock:^(id  _Nonnull data) {
         [SVProgressHUD dismiss];
         [WMHUDUntil showMessageToWindow:@"获取验证码失败"];
     }];
    
    
}

- (void)verifyCode:(NSString *)code{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth *3, 0) animated:YES];
    return;
       [SVProgressHUD show];
       [LWLoginCoordinator verifyEmailCodeWithEmail:self.emailStr andCode:code WithSuccessBlock:^(id  _Nonnull data) {
           id dataID = [data objectForKey:@"data"];
           if (![dataID isKindOfClass:[NSDictionary class]]) {
               if (dataID == NO || [dataID integerValue] == 0) {
                    [SVProgressHUD dismiss];
                    [WMHUDUntil showMessageToWindow:@"验证失败"];
                    return ;
                }
           }
    
           NSDictionary *dataDic = (NSDictionary *)dataID;
           if(dataDic && dataDic.allKeys.count>0){
               [[LWUserManager shareInstance] setUserDic:dataDic];
               [[LWUserManager shareInstance] setEmail:self.emailStr];
               if([[LWUserManager shareInstance] getUserModel].uid.length>0){//老用户
                   [SVProgressHUD dismiss];
                   

               }else{
                   [self.scrollView setContentOffset:CGPointMake(kScreenWidth *3, 0) animated:YES];
               }
           }else{
               [WMHUDUntil showMessageToWindow:@"验证失败"];
           }
       } WithFailBlock:^(id  _Nonnull data) {
           [SVProgressHUD dismiss];
       }];
}

#pragma mark - recover
- (void)getRecoverEmailCodeClick:(NSString *)email{
    [SVProgressHUD show];
    [LWLoginCoordinator getSMSCodeWithEmail:email WithSuccessBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:@"验证码发送成功"];
//跳转至恢复二级页面

    } WithFailBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:@"获取验证码失败"];
    }];
}

- (void)verifyRecoverEmailClick:(NSString *)code{
    [SVProgressHUD show];
    [LWLoginCoordinator verifyEmailCodeWithEmail:self.emailStr andCode:code WithSuccessBlock:^(id  _Nonnull data) {
        id dataID = [data objectForKey:@"data"];
        if (![dataID isKindOfClass:[NSDictionary class]]) {
            if (dataID == NO || [dataID integerValue] == 0) {
                 [SVProgressHUD dismiss];
                 [WMHUDUntil showMessageToWindow:@"验证失败"];
                 return ;
             }
        }
 
        NSDictionary *dataDic = (NSDictionary *)dataID;
        if(dataDic && dataDic.allKeys.count>0){
            [[LWUserManager shareInstance] setUserDic:dataDic];
            [[LWUserManager shareInstance] setEmail:self.emailStr];
            if([[LWUserManager shareInstance] getUserModel].uid.length>0){//老用户
                [SVProgressHUD dismiss];
//                [self jumpToRecoveryVC];
            }else{
                [self registerMethod];
            }
        }else{
            [WMHUDUntil showMessageToWindow:@"验证失败"];
        }
    } WithFailBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - register
- (void)registerMethod{
    [SVProgressHUD show];
    
    char *seed = get_seed();
    char *pk = derive_key(seed, [LWAddressTool stringToChar:@"m/0"]);
    char *secret = sha256(pk);
    char *shares = get_shares(seed, 2, 2);
    char *recover_seed = combine_shares(shares);
    char *publickey = get_public_key(pk);
    char *xpub = get_xpub(seed);
    NSString *shares_str = [LWAddressTool charToString:shares];
    NSArray *sharesArray = [NSJSONSerialization JSONObjectWithData:[shares_str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    char *sig = get_message_sig([LWAddressTool stringToChar:self.emailStr], pk);
    
    
    NSDictionary *initDic = @{@"pk":[LWAddressTool charToString:pk],
                              @"publicKey":[LWAddressTool charToString:publickey],
                              @"secret":[LWAddressTool charToString:secret],
                              @"seed":[LWAddressTool charToString:seed],
                              @"xpub":[LWAddressTool charToString:xpub],
                              @"sig":[LWAddressTool charToString:sig],
                              @"shares":sharesArray
                            };
    
    NSArray *trusteeArrar = [[LWTrusteeManager shareInstance] getTrusteeArray];

    NSString *dpStr = [NSString stringWithFormat:@"%s",get_random_key_pair()];
    NSData * jsonData = [dpStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dpArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableDictionary *sharesDic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < trusteeArrar.count; i++) {
        LWTrusteeModel *model = trusteeArrar[i];
        NSString *encriData = [LWEncryptTool encryptWithPk:[LWAddressTool charToString:pk] pubkey:model.publicKey andMessage:sharesArray[i]];
        [sharesDic setObj:encriData forKey:model.name];
         if (i == trusteeArrar.count - 1){
             [self manageDkWithSecret:[LWAddressTool charToString:secret] andpJoin:dpArray andShares:sharesDic andinfoDic:initDic];
         }
    }
}

- (void)manageDkWithSecret:(NSString *)secret andpJoin:(NSArray *)dpArray andShares:(NSDictionary *)encryptShares andinfoDic:(NSDictionary *)data{
    
    NSString *d = dpArray.firstObject;
    NSString *p = dpArray.lastObject;
    
    NSString *ek = [NSString stringWithFormat:@"%s",get_encryption_key([d cStringUsingEncoding:NSASCIIStringEncoding], [p cStringUsingEncoding:NSASCIIStringEncoding])];
    NSString *sig = [data objectForKey:@"sig"];
    NSString *xpub = [data objectForKey:@"xpub"];
    NSString *encryptStr = [LWEncryptTool encrywithTheKey:secret message:dpArray andHex:1];
    NSDictionary *params = @{@"email":self.emailStr,
                             @"xpub":xpub,
                             @"sig":sig,
                             @"ek":ek,
                             @"dk":encryptStr,
                             @"shares":encryptShares,
                             @"token":[[LWUserManager shareInstance] getUserModel].token
    };
    [self loginRequestWithParams:params];
}

- (void)loginRequestWithParams:(NSDictionary *)loginParams{
    [LWLoginCoordinator registerUserWithParams:loginParams WithSuccessBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        LWUserModel *model = [[LWUserManager shareInstance] getUserModel];
        model.uid = [data objectForKey:@"uid"];
        model.secret = [data objectForKey:@"secret"];
        model.login_token = [data objectForKey:@"login_token"];
        [[LWUserManager shareInstance] setUser:model];
        
//        LWFaceBindViewController *lwfaceVC = [[LWFaceBindViewController alloc]init];
//        [self.navigationController pushViewController:lwfaceVC animated:YES];
        
    } WithFailBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:@"fail"];
    }];
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
