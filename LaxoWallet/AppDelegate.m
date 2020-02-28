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

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self getTrueteeData];
    [self getCurrentTokenPrice];
//    [LogicHandle showTabbarVC];
//    [LogicHandle chooseStartVC];
    [LogicHandle showLoginVC];
    [self.window makeKeyAndVisible];
    
    return YES;
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
