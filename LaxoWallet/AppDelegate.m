//
//  AppDelegate.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/4.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "AppDelegate.h"
#import "LWLoginViewController.h"
#import "LWLoginCoordinator.h"
#import "LWHomeListCoordinator.h"

#import "PublicKeyView.h"
#import "LWRocoveryViewController.h"
#import "LWFaceBindViewController.h"
#import "LWPersonalWalletDetailViewController.h"

#import "LWUserVefifyViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import <Bugly/Bugly.h>

#import "LWCurrentExchangeTool.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIVisualEffectView *blurView;
@end

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [_blurView removeFromSuperview];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
     if(!_blurView) {
     UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
     _blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     _blurView.frame = self.window.bounds;
     }
    //进入后台实现模糊效果
     [self.window addSubview:_blurView];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD dismissWithDelay:10];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self getTrueteeData];
    [self getCurrencyToUSD];
    [[LWCurrentExchangeTool shareInstance] getCurrentExchange];
    [self registerBDFace];
    
//    [LogicHandle showTabbarVC];
    [LogicHandle chooseStartVC];
//    [LogicHandle showLoginVC];

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self registerBugly];
    });
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)getCurrencyToUSD{
    [LWHomeListCoordinator getCurrentCurrencyWithUSDWithSuccessBlock:^(id  _Nonnull data) {
        
    } WithFailBlock:^(id  _Nonnull data) {
        [self getCurrencyToUSD];
    }];
}

- (void)getTrueteeData{
    [LWLoginCoordinator getTrueteeDataWithSuccessBlock:^(id  _Nonnull data) {
        
    } WithFailBlock:^(id  _Nonnull data) {
        [self getTrueteeData];
    }];
}

- (void)registerBDFace{
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
     NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
     [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
}

- (void)registerBugly{
    [Bugly startWithAppId:@"d91b4ca720"       ];
}

@end
