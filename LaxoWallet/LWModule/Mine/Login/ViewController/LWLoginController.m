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
#import "LWLoginStepFiveViewOne.h"
#import "LWLoginStepFiveView.h"
#import "LWLoginStepSixView.h"
#import "LWLoginStepSevenView.h"
#import "LWLoginStepEightView.h"
#import "LWLoginStepSuccessView.h"

#import "LWLoginCoordinator.h"

#import "libthresholdsig.h"
#import "LWAddressTool.h"

#import "LivenessViewController.h"
#import "DetectionViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import "LWCommonBottomBtn.h"

#import "QQLBXScanViewController.h"
#import "LBXPermission.h"
#import "iCloudHandle.h"

@interface LWLoginController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *scrollBackView;

@property (nonatomic, strong) NSString *emailStr;
@property (nonatomic, strong) NSString *recoverProcess;

@property (nonatomic, assign) BOOL isRegister;
@property (nonatomic, assign) BOOL canRecoverFromICloud;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation LWLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   [[LWUserManager shareInstance] clearUser];
    [self createUI];
    [LWPublicManager getInitData];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex = 1;
    CGFloat topHeight = kStatusBarHeight + 140;
    CGFloat viewHeight = kScreenHeight - (kStatusBarHeight + 140);

    UIScrollView *scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topHeight, kScreenWidth, viewHeight)];
    scrollView1.showsVerticalScrollIndicator = NO;
    scrollView1.showsHorizontalScrollIndicator = NO;
    scrollView1.scrollsToTop = NO;
    scrollView1.tag = 1;
    scrollView1.backgroundColor = [UIColor whiteColor];
    scrollView1.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    [self.view addSubview:scrollView1];
    
    LWLoginStepOneView *viewOne = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepOneView class]) owner:nil options:nil].lastObject;
    viewOne.frame = CGRectMake(0, 0, kScreenWidth,viewHeight);
    viewOne.block = ^{
        [self scrollWithIndex:2];
    };
    [scrollView1 addSubview:viewOne];
    
    UIScrollView *scrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, topHeight, kScreenWidth, viewHeight)];
    scrollView2.showsVerticalScrollIndicator = NO;
    scrollView2.showsHorizontalScrollIndicator = NO;
    scrollView2.scrollsToTop = NO;
    scrollView2.backgroundColor = [UIColor whiteColor];
    scrollView2.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    scrollView2.tag = 2;
    [self.view addSubview:scrollView2];
    
    LWLoginStepTwoView *view2 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepTwoView class]) owner:nil options:nil].lastObject;
    view2.frame = CGRectMake(0, 0, kScreenWidth,viewHeight);
    view2.block = ^(NSString * _Nonnull email) {
        [self verifyEmail:email];
    };
    [scrollView2 addSubview:view2];

    UIScrollView *scrollView3 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, topHeight, kScreenWidth, viewHeight)];
    scrollView3.showsVerticalScrollIndicator = NO;
    scrollView3.showsHorizontalScrollIndicator = NO;
    scrollView3.scrollsToTop = NO;
    scrollView3.backgroundColor = [UIColor whiteColor];
    scrollView3.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    scrollView3.tag = 3;
    [self.view addSubview:scrollView3];
    
    LWLoginStepThreeView *view3 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepThreeView class]) owner:nil options:nil].lastObject;
    view3.frame = CGRectMake(0 * 2, 0, kScreenWidth,viewHeight);
    [scrollView3 addSubview:view3];
    view3.block = ^(NSString * _Nonnull code) {
        [self verifyCode:code];
    };
    [scrollView3 addSubview:view3];
    
    UIScrollView *scrollView4 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, topHeight, kScreenWidth, viewHeight)];
    scrollView4.showsVerticalScrollIndicator = NO;
    scrollView4.showsHorizontalScrollIndicator = NO;
    scrollView4.scrollsToTop = NO;
    scrollView4.backgroundColor = [UIColor whiteColor];
    scrollView4.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    [self.view addSubview:scrollView4];
    scrollView4.tag = 4;

    LWLoginStepFourView *view4 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepFourView class]) owner:nil options:nil].lastObject;
    view4.frame = CGRectMake(0 * 3, 0, kScreenWidth,viewHeight);
    view4.block = ^(NSInteger type) {
        NSArray *array = @[@(1),@(type)];
        LWUserModel *user = [[LWUserManager shareInstance] getUserModel];
        user.trusthold = array;
        [[LWUserManager shareInstance] setUser:user];
        [self registerMethod];
    };
    [scrollView4 addSubview:view4];
    
    UIScrollView *scrollView5 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, topHeight, kScreenWidth, viewHeight)];
    scrollView5.showsVerticalScrollIndicator = NO;
    scrollView5.showsHorizontalScrollIndicator = NO;
    scrollView5.scrollsToTop = NO;
    scrollView5.backgroundColor = [UIColor whiteColor];
    scrollView5.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    [self.view addSubview:scrollView5];
    scrollView5.tag = 5;

    LWLoginStepFiveView *view5 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepFiveView class]) owner:nil options:nil].lastObject;
    view5.frame = CGRectMake(0 * 4, 0, kScreenWidth,viewHeight);
    view5.block = ^{
        [self getTheCameraAuth];
    };
    [scrollView5 addSubview:view5];

    UIScrollView *scrollView51 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, topHeight, kScreenWidth, viewHeight)];
    scrollView51.showsVerticalScrollIndicator = NO;
    scrollView51.showsHorizontalScrollIndicator = NO;
    scrollView51.scrollsToTop = NO;
    scrollView51.backgroundColor = [UIColor whiteColor];
    scrollView51.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    [self.view addSubview:scrollView51];
    scrollView51.tag = 51;

    LWLoginStepFiveViewOne *view51 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepFiveViewOne class]) owner:nil options:nil].lastObject;
    view51.frame = CGRectMake(0 * 4, 0, kScreenWidth,viewHeight);
    view51.block = ^{
        [self getTheCameraAuth];
    };
    [scrollView51 addSubview:view51];
    
    UIScrollView *scrollView6 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth,topHeight, kScreenWidth, viewHeight)];
    scrollView6.showsVerticalScrollIndicator = NO;
    scrollView6.showsHorizontalScrollIndicator = NO;
    scrollView6.scrollsToTop = NO;
    scrollView6.backgroundColor = [UIColor whiteColor];
    scrollView6.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    [self.view addSubview:scrollView6];
    scrollView6.tag = 6;

    LWLoginStepSixView *view6 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepSixView class]) owner:nil options:nil].lastObject;
    view6.frame = CGRectMake(0 * 5, 0, kScreenWidth,viewHeight);
    view6.sixBlock = ^(NSInteger index) {
        if (index == 1) {//二维码恢复
            [self scrollWithIndex:8];
//            [self.scrollView setContentOffset:CGPointMake(kScreenWidth *7, 0) animated:YES];
        }else if(index == 2){//短信验证码恢复
            [self getRecoverEmailCodeClick:[[LWUserManager shareInstance]getUserModel].email ];
        }
    };
    [scrollView6 addSubview:view6];
    
    UIScrollView *scrollView7 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, topHeight, kScreenWidth, viewHeight)];
    scrollView7.showsVerticalScrollIndicator = NO;
    scrollView7.showsHorizontalScrollIndicator = NO;
    scrollView7.scrollsToTop = NO;
    scrollView7.backgroundColor = [UIColor whiteColor];
    scrollView7.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    [self.view addSubview:scrollView7];
    scrollView7.tag = 7;

    LWLoginStepSevenView *view7 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepSevenView class]) owner:nil options:nil].lastObject;
    view7.frame = CGRectMake(0 * 6, 0, kScreenWidth,viewHeight);
    view7.sevenBlock = ^(NSString * _Nonnull msgCode) {
        [self thrustholdsrecover:msgCode];
    };
    [scrollView7 addSubview:view7];
    
    UIScrollView *scrollView8 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, topHeight, kScreenWidth, viewHeight)];
    scrollView8.showsVerticalScrollIndicator = NO;
    scrollView8.showsHorizontalScrollIndicator = NO;
    scrollView8.scrollsToTop = NO;
    scrollView8.backgroundColor = [UIColor whiteColor];
    scrollView8.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    [self.view addSubview:scrollView8];
    scrollView8.tag = 8;

    LWLoginStepEightView *view8 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepEightView class]) owner:nil options:nil].lastObject;
    view8.frame = CGRectMake(0 * 7, 0, kScreenWidth,viewHeight);
    view8.block = ^(NSInteger index) {
        if (index == 1) {
            [self jumpToScanPermission];
        }else if (index == 2){
            [self qrcodeRecover];
        }else if (index == 3){
            [self getRecoverEmailCodeClick:[[LWUserManager shareInstance] getUserModel].email];
        }
    };
    [scrollView8 addSubview:view8];
    
    UIScrollView *scrollView9 = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth,topHeight, kScreenWidth, viewHeight)];
    scrollView9.showsVerticalScrollIndicator = NO;
    scrollView9.showsHorizontalScrollIndicator = NO;
    scrollView9.scrollsToTop = NO;
    scrollView9.backgroundColor = [UIColor whiteColor];
    scrollView9.contentSize= CGSizeMake(kScreenWidth, viewHeight);
    [self.view addSubview:scrollView9];
    scrollView9.tag = 9;

    LWLoginStepSuccessView *view9 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginStepSuccessView class]) owner:nil options:nil].lastObject;
    view9.frame = CGRectMake(0 * 8, 0, kScreenWidth,viewHeight);
    [scrollView9 addSubview:view9];
    
    if (kScreenWidth == 375) {
        scrollView1.contentSize= CGSizeMake(kScreenWidth, 620);
        viewOne.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView2.contentSize= CGSizeMake(kScreenWidth, 620);
        view2.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView3.contentSize= CGSizeMake(kScreenWidth, 620);
        view3.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView4.contentSize= CGSizeMake(kScreenWidth, 620);
        view4.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView5.contentSize= CGSizeMake(kScreenWidth, 620);
        view5.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView51.contentSize= CGSizeMake(kScreenWidth, 620);
        view51.frame = CGRectMake(0, 0, kScreenWidth,620);
        
        scrollView6.contentSize= CGSizeMake(kScreenWidth, 620);
        view6.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView7.contentSize= CGSizeMake(kScreenWidth, 620);
        view7.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView8.contentSize= CGSizeMake(kScreenWidth, 620);
        view8.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView9.contentSize= CGSizeMake(kScreenWidth, 620);
        scrollView9.contentSize= CGSizeMake(kScreenWidth, 620);

    }else if (kScreenWidth == 320){
        scrollView1.contentSize= CGSizeMake(kScreenWidth, 530);
        viewOne.frame = CGRectMake(0, 0, kScreenWidth,530);

        scrollView2.contentSize= CGSizeMake(kScreenWidth, 530);
        view2.frame = CGRectMake(0, 0, kScreenWidth,530);

        scrollView3.contentSize= CGSizeMake(kScreenWidth, 530);
        view3.frame = CGRectMake(0, 0, kScreenWidth,530);

        scrollView4.contentSize= CGSizeMake(kScreenWidth, 620);
        view4.frame = CGRectMake(0, 0, kScreenWidth,620);

        scrollView5.contentSize= CGSizeMake(kScreenWidth, 680);
        view5.frame = CGRectMake(0, 0, kScreenWidth,680);

        scrollView51.contentSize= CGSizeMake(kScreenWidth, 680);
        view51.frame = CGRectMake(0, 0, kScreenWidth,680);
        
        scrollView6.contentSize= CGSizeMake(kScreenWidth, 530);
        view6.frame = CGRectMake(0, 0, kScreenWidth,530);

        scrollView7.contentSize= CGSizeMake(kScreenWidth, 530);
        view7.frame = CGRectMake(0, 0, kScreenWidth,530);

        scrollView8.contentSize= CGSizeMake(kScreenWidth, 530);
        view8.frame = CGRectMake(0, 0, kScreenWidth,530);

        scrollView9.contentSize= CGSizeMake(kScreenWidth, 580);
        view9.frame = CGRectMake(0, 0, kScreenWidth,580);
    }
}

- (void)scrollWithIndex:(NSInteger)selectIndex{
    
    UIView *view1 = [self.view viewWithTag:self.currentIndex];
    UIView *view2 = [self.view viewWithTag:selectIndex];
    [UIView animateWithDuration:0.3 animations:^{
        view1.kleft = - kScreenWidth;
        view2.kleft = 0;
    }];
    self.currentIndex = selectIndex;
}

#pragma mark - requetmethod
- (void)verifyEmail:(NSString *)email{

    [SVProgressHUD show];
     NSString *emailStr = email;
     [LWLoginCoordinator getSMSCodeWithEmail:emailStr WithSuccessBlock:^(id  _Nonnull data) {
         [SVProgressHUD dismiss];
         [self scrollWithIndex:3];
         self.emailStr = email;
     } WithFailBlock:^(id  _Nonnull data) {
         [SVProgressHUD dismiss];
         [WMHUDUntil showMessageToWindow:kLocalizable(@"login_fail_msgCode")];
     }];
}

- (void)verifyCode:(NSString *)code{
       [SVProgressHUD show];
       [LWLoginCoordinator verifyEmailCodeWithEmail:self.emailStr andCode:code WithSuccessBlock:^(id  _Nonnull data) {
           id dataID = [data objectForKey:@"data"];
           if (![dataID isKindOfClass:[NSDictionary class]]) {
               if (dataID == NO || [dataID integerValue] == 0) {
                    [SVProgressHUD dismiss];
                   [WMHUDUntil showMessageToWindow:kLocalizable(@"login_error_code")];
                    return ;
                }
           }
    
           NSDictionary *dataDic = (NSDictionary *)dataID;
           if(dataDic && dataDic.allKeys.count>0){
               [SVProgressHUD dismiss];
               [[LWUserManager shareInstance] setUserDic:dataDic];
               [[LWUserManager shareInstance] setEmail:self.emailStr];
               NSString *uid =  [dataDic ds_stringForKey:@"uid"];
               
               if(uid && uid.length>0){//老用户
                   [self scrollWithIndex:51];
//                   [self.scrollView setContentOffset:CGPointMake(kScreenWidth *4, 0) animated:NO];
               }else{//新用户
                   //选择thrustholds
                   self.isRegister = YES;
                   NSArray *array = @[@(1),@(2)];
                   LWUserModel *user = [[LWUserManager shareInstance] getUserModel];
                   user.trusthold = array;
                   [[LWUserManager shareInstance] setUser:user];
                   [self registerMethod];
//                   [self scrollWithIndex:4];
//                   [self.scrollView setContentOffset:CGPointMake(kScreenWidth *3, 0) animated:YES];
               }
           }else{
               [WMHUDUntil showMessageToWindow:kLocalizable(@"login_error_code")];
           }
       } WithFailBlock:^(id  _Nonnull data) {
           [SVProgressHUD dismiss];
       }];
}

#pragma mark - recover
- (void)getRecoverEmailCodeClick:(NSString *)email{
    [SVProgressHUD show];
    
    NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        for (NSInteger i = 0; i<array.count; i++) {
             
            LWTrusteeModel *model = [array objectAtIndex:i];
            [LWLoginCoordinator getRecoverySMSCodeWithModel:model SuccessBlock:^(id  _Nonnull data) {
                if (i == array.count - 1) {
                    if ([[data objectForKey:@"success"]integerValue] == 1) {
                        [self scrollWithIndex:7];
                    }

//                       [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 6, 0)];
//                       [WMHUDUntil showMessageToWindow:@"验证码发送成功"];
                   }
                  dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
              } WithFailBlock:^(id  _Nonnull data) {
                  
                  [WMHUDUntil showMessageToWindow:kLocalizable(@"login_fail_request")];
                  dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
                  return ;
              }];
             dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
         }
    });
    
    
    
//    [LWLoginCoordinator getRecoverySMSCodeWithModel:<#(nonnull LWTrusteeModel *)#> SuccessBlock:<#^(id  _Nonnull data)successBlock#> WithFailBlock:<#^(id  _Nonnull data)FailBlock#>]
//
//    [LWLoginCoordinator getSMSCodeWithEmail:email WithSuccessBlock:^(id  _Nonnull data) {
//        [SVProgressHUD dismiss];
////        [WMHUDUntil showMessageToWindow:@"验证码发送成功"];
//        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 6, 0)];
//    } WithFailBlock:^(id  _Nonnull data) {
//        [SVProgressHUD dismiss];
//        [WMHUDUntil showMessageToWindow:@"get code fail"];
//    }];
}

- (void)verifyRecoverEmailClick:(NSString *)code{
    [SVProgressHUD show];
    [LWLoginCoordinator verifyEmailCodeWithEmail:self.emailStr andCode:code WithSuccessBlock:^(id  _Nonnull data) {
        id dataID = [data objectForKey:@"data"];
        if (![dataID isKindOfClass:[NSDictionary class]]) {
            if (dataID == NO || [dataID integerValue] == 0) {
                 [SVProgressHUD dismiss];
                [WMHUDUntil showMessageToWindow:kLocalizable(@"login_error_code")];
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
            [WMHUDUntil showMessageToWindow:kLocalizable(@"login_error_code")];
        }
    } WithFailBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - register
- (void)registerMethod{
    [SVProgressHUD show];
    
    char *seed = get_seed();
    LWUserModel *model = [[LWUserManager shareInstance] getUserModel];
    model.jiZhuCi = [LWAddressTool charToString:seed];
    [[LWUserManager shareInstance] setUser:model];
    
    char *pk = derive_key(seed, [LWAddressTool stringToChar:@"m/0"]);
    char *secret = sha256(pk);
    char *shares = get_shares(seed, 2, 2);
//    char *recover_seed = combine_shares(shares);
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
        model.uid = [NSString stringWithFormat:@"%@",[data objectForKey:@"uid"]];
        model.secret = [data objectForKey:@"secret"];
        model.login_token = [data objectForKey:@"login_token"];
//        model.jiZhuCi = [loginParams objectForKey:@"seed"];
        [[LWUserManager shareInstance] setUser:model];
        [self scrollWithIndex:5];

//        [self.scrollView setContentOffset:CGPointMake(kScreenWidth *4, 0) animated:NO];
//        LWFaceBindViewController *lwfaceVC = [[LWFaceBindViewController alloc]init];
//        [self.navigationController pushViewController:lwfaceVC animated:YES];
        
    } WithFailBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:kLocalizable(@"login_fail_register")];
    }];
}

#pragma mark - face

- (void)getTheCameraAuth{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted|| authStatus == AVAuthorizationStatusDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [WMHUDUntil showMessageToWindow:kLocalizable(@"login_permission_camera")];
        });
        // 获取摄像头失败
    }else if(authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusAuthorized){
        //判断点击是允许还是拒绝
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {// 获取摄像头成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self bottom2Click];
                });
            }else {// 获取摄像头失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WMHUDUntil showMessageToWindow:kLocalizable(@"login_permission_camera")];
                });
            }
        }];
    }else{
        // 获取摄像头成功
    }

}

- (void)bottom1Click{
    if ([[FaceSDKManager sharedInstance] canWork]) {
         NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
         [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
     }
    
     DetectionViewController* dvc = [[DetectionViewController alloc] init];
     dvc.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:dvc animated:YES completion:nil];
    
    dvc.successBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [dvc dismissViewControllerAnimated:YES completion:nil];
            [self bottom2Click];
        });
    };
}

- (void)bottom2Click{
    
    LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
    BOOL firstBindFace;
    if (!userModel.face_enable || userModel.face_enable == 0) {
       //跳转至人脸识别,绑定人脸
        firstBindFace = YES;
    }else{
        firstBindFace = NO;
    }

     if ([[FaceSDKManager sharedInstance] canWork]) {
         NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
         [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
         
     }
     LivenessViewController* lvc = [[LivenessViewController alloc] init];
    lvc.firstBindFace = firstBindFace;
     LivingConfigModel* model = [LivingConfigModel sharedInstance];
     [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    lvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:lvc animated:YES completion:nil];
    lvc.livenessBlock = ^(NSString *face_token) {
        LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
        userModel.face_token = face_token;
        [[LWUserManager shareInstance] setUser:userModel];
        if (face_token && face_token.length > 0) {
            if (self.isRegister) {
                [self scrollWithIndex:9];

//                [self.scrollView setContentOffset:CGPointMake(kScreenWidth *8, 0) animated:NO];
            }else{
//                [self.scrollView setContentOffset:CGPointMake(kScreenWidth *5, 0) animated:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD show];
                    [self recoverWithICloud:^(BOOL isIcloudRecover) {
                        if (isIcloudRecover) {
                            [SVProgressHUD dismiss];
                            [self scrollWithIndex:9];
                        }else{
                            [self getRecoverEmailCodeClick:[[LWUserManager shareInstance]getUserModel].email ];
                            [self scrollWithIndex:6];
                        }
                    }];
                });
            }
        }else{
//            [WMHUDUntil showMessageToWindow:@"face error"];
        }
    };
}

#pragma mark - thrustholds recover
- (void)thrustholdsrecover:(NSString *)msgCode{
    
    NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];
    NSMutableArray *seedDataArray = [NSMutableArray array];
    [SVProgressHUD show];

    LWTrusteeModel *model = [array objectAtIndex:0];
    [LWLoginCoordinator verifyRecoveryEmailCodeWithCode:msgCode andModel:model WithSuccessBlock:^(id  _Nonnull data) {
        NSLog(@"data%@",[data objectForKey:@"data"]);
        [seedDataArray addObject:[data objectForKey:@"data"]];
        
        LWTrusteeModel *model1 = [array objectAtIndex:1];

        [LWLoginCoordinator verifyRecoveryEmailCodeWithCode:msgCode andModel:model1 WithSuccessBlock:^(id  _Nonnull data) {
                    NSLog(@"data%@",[data objectForKey:@"data"]);
                    [seedDataArray addObject:[data objectForKey:@"data"]];
                        [self calculateSeed:seedDataArray];

               
            } WithFailBlock:^(id  _Nonnull data) {
                [WMHUDUntil showMessageToWindow:kLocalizable(@"login_TrustholdVerifyFail")];
        }];

        } WithFailBlock:^(id  _Nonnull data) {

    }];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
//        for (NSInteger i = 0; i<2; i++) {
//            LWTrusteeModel *model = [array objectAtIndex:i];
//
//            [LWLoginCoordinator verifyRecoveryEmailCodeWithCode:msgCode andModel:model WithSuccessBlock:^(id  _Nonnull data) {
//                NSLog(@"data%@",[data objectForKey:@"data"]);
//                [seedDataArray addObject:[data objectForKey:@"data"]];
//                if (i == 1) {//最后一次 根据data 计算seed
//                    [self calculateSeed:seedDataArray];
//                }
//                dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
//
//            } WithFailBlock:^(id  _Nonnull data) {
//                dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
//            }];
//            dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
//        }
//    });
}

- (void)calculateSeed:(NSArray *)dataArray{
//    NSString *prikey = [PubkeyManager getPrikey];
    NSString *prikey = [LWPublicManager getInitDataPK];

    NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];

    NSMutableArray *mutableDecripArr = [NSMutableArray array];
    for (NSInteger i = 0; i<2; i++) {
        LWTrusteeModel *model = [array objectAtIndex:i];
        NSString *pubkey = model.publicKey;
        NSString *decryptData = [LWEncryptTool decryptWithPk:prikey pubkey:pubkey andMessage:dataArray[i]];
        [mutableDecripArr addObject:decryptData];
        if(i == 1){
            [SVProgressHUD dismiss];
            [self getRecoverData:mutableDecripArr];
            NSLog(@"success:\n%@",mutableDecripArr);
        }

    }
}

- (void)getRecoverData:(NSArray *)array{
    
    LWUserModel *model = [[LWUserManager shareInstance] getUserModel];
    model.jiZhuCi = [LWPublicManager getRecoverJizhuciWithShares:array];
    [[LWUserManager shareInstance] setUser:model];
    [self scrollWithIndex:9];
//    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 8, 0) animated:NO];

}

#pragma mark - qrcodeRecover
- (void)qrcodeRecover{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:kLocalizable(@"common_remind") msg:kLocalizable(@"login_permission_album") cancel:kLocalizable(@"common_cancel") setting:kLocalizable(@"common_setting")];

        //    [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"Remind" msg:@"No album permissions, whether to go to Settings" cancel:@"Cancel" setting:@"Setting"];
        }
    }];
}

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto:(BOOL)allowsEditing{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //部分机型有问题
    picker.allowsEditing = allowsEditing;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [LBXZBarWrapper recognizeImage:image block:^(NSArray<LBXZbarResult *> *result) {
        if (result.count == 0 || !result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WMHUDUntil showMessageToWindow:kLocalizable(@"login_error_image")];
            });
            return ;
        }
        
        LBXZbarResult *firstObj = result[0];
        NSString *scanedStr = firstObj.strScanned;
        if(scanedStr && scanedStr.length>0){
            [self recoverWithScanedStr:scanedStr];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [WMHUDUntil showMessageToWindow:kLocalizable(@"login_error_image")];
            });
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)recoverWithScanedStr:(NSString *)scanStr{
    [SVProgressHUD dismiss];

    NSString *jizhuci = [LWEncryptTool decryptwithTheKey:[[[LWUserManager shareInstance] getUserModel].secret md5String]  message:scanStr andHex:0];
    if (!jizhuci || jizhuci == nil || jizhuci.length == 0) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"login_error_qrCode")];

    }else{
        [[LWUserManager shareInstance] setJiZhuCi:jizhuci];
        [self scrollWithIndex:9];
//        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 8, 0) animated:NO];
    }
}

#pragma mark recoverWithIcloud
- (void)recoverWithICloud:(void(^)(BOOL isIcloudRecover))successBlock{
#if DEBUG
    successBlock(NO);
    return;
#endif
    
    NSString *recoverCode = [iCloudHandle getKeyValueICloudStoreWithKey:self.emailStr];
    if (recoverCode && recoverCode.length >0) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"login_RecoveringFromICloud")];

//        [SVProgressHUD showWithStatus:@"Recovering From ICloud"];
        
         NSString *jizhuci = [LWEncryptTool decryptwithTheKey:[[[LWUserManager shareInstance] getUserModel].secret md5String]  message:recoverCode andHex:0];
         if (!jizhuci || jizhuci == nil || jizhuci.length == 0) {
             [WMHUDUntil showMessageToWindow:kLocalizable(@"login_error_qrCode")];
             successBlock(NO);

         }else{
             [[LWUserManager shareInstance] setJiZhuCi:jizhuci];
             successBlock(YES);
//             [self scrollWithIndex:9];
     //        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 8, 0) animated:NO];
         }
        
//        [self recoverWithScanedStr:recoverCode];
    }else{
        successBlock(NO);
    }
    
    
    
    
}

#pragma mark qrscan
- (void)jumpToScanPermission {
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf jumpToScan];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:kLocalizable(@"common_remind") msg:kLocalizable(@"login_permission_album") cancel:kLocalizable(@"common_cancel") setting:kLocalizable(@"common_setting")];
        }
    }];
    

}
- (void)jumpToScan{
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
    vc.libraryType = SLT_ZXing;
    //       vc.scanCodeType = [Global sharedManager].scanCodeType;

    vc.style = [QQLBXScanViewController qqStyle];
    vc.scanresult = ^(LBXScanResult *result) {
        NSString *qrcodel = result.strScanned;
        [self recoverWithScanedStr:qrcodel];
    };
    //镜头拉远拉近功能
    vc.isVideoZoom = YES;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:[[LWNavigationViewController alloc] initWithRootViewController:vc] animated:YES completion:nil];
//    [LogicHandle pushViewController:vc];
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
