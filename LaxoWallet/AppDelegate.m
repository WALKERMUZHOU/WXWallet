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

#import "LWUserVefifyViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self getTrueteeData];
    [self getCurrentTokenPrice];
    [self registerBDFace];
    
    [LogicHandle showTabbarVC];
//    [LogicHandle chooseStartVC];
//    [LogicHandle showLoginVC];
    
//    LWUserVefifyViewController *launchVC = [[LWUserVefifyViewController alloc] init];
//    self.window.rootViewController = launchVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)registerBDFace{
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
     NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
     [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
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

- (void)getTrueteeData{
    [LWLoginCoordinator getTrueteeDataWithSuccessBlock:^(id  _Nonnull data) {
        
    } WithFailBlock:^(id  _Nonnull data) {
        [self getTrueteeData];
    }];
}

- (void)getCurrentTokenPrice{
    [LWHomeListCoordinator getTokenPriceWithSuccessBlock:^(id  _Nonnull data) {
        
    } WithFailBlock:^(id  _Nonnull data) {
        [self getCurrentTokenPrice];
    }];
}
@end
