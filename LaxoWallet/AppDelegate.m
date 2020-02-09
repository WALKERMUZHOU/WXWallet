//
//  AppDelegate.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/4.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "AppDelegate.h"
#import "LWLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
        self.tabBarVC = [[LWTabBarViewController alloc]init];
    //    self.window.rootViewController = self.tabBarVC;
    //    XDYLoginVC *vc = [[XDYLoginVC alloc] initWithNibName:@"XDYLoginVC" bundle:nil];
        
    //    LWHomeViewController *homeVC = [[LWHomeViewController alloc]init];
    //    self.window.rootViewController = homeVC;
        
        LWLoginViewController *loginVC = [[LWLoginViewController alloc]initWithNibName:@"LWLoginViewController" bundle:nil];
    //    LWLoginViewController *loginVC = [[LWLoginViewController alloc]init];
    
    [self.window setRootViewController:loginVC];
    [self.window makeKeyAndVisible];

    
    // Override point for customization after application launch.
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


@end
