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

@end

@implementation AppDelegate

@synthesize window = _window;

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
//    [LogicHandle chooseStartVC];
    [LogicHandle showLoginVC];
    
    LWUserVefifyViewController *launchVC = [[LWUserVefifyViewController alloc] init];
//    self.window.rootViewController = launchVC;
    LWPersonalWalletDetailViewController *personalVC = [[LWPersonalWalletDetailViewController alloc] init];
//    self.window.rootViewController = [[LWNavigationViewController alloc] initWithRootViewController:personalVC];;

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

#pragma mark - UISceneSession lifecycle

//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

- (void)getInitData{
    [self getTrueteeData];
}

- (void)getCurrentTokenPrice{
    [LWHomeListCoordinator getTokenPriceWithSuccessBlock:^(id  _Nonnull data) {
        
    } WithFailBlock:^(id  _Nonnull data) {
        [self getCurrentTokenPrice];
    }];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//        dispatch_source_set_event_handler(timer, ^{
//            [LWHomeListCoordinator getTokenPriceWithSuccessBlock:^(id  _Nonnull data) {
//                    
//            } WithFailBlock:^(id  _Nonnull data) {
//                    [self getCurrentTokenPrice];
//            }];
//        });
//        dispatch_resume(timer);
//    });

    
    

}
@end
