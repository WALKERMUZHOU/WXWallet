//
//  LogicHandle.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/6.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LogicHandle.h"
#import "LWLoginViewController.h"

@implementation LogicHandle


+ (void)pushViewController:(UIViewController *)viewController{
    AppDelegate *appdelete = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIViewController *selectVC = appdelete.window.rootViewController;
    if ([selectVC isKindOfClass:[LWNavigationViewController class]]) {
        [(LWNavigationViewController *)selectVC pushViewController:viewController animated:YES];
    }else if ([selectVC isKindOfClass:[LWTabBarViewController class]]){
        AppDelegate *appdelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LWNavigationViewController *naviVC = (LWNavigationViewController *)appdelete.tabBarVC.selectedViewController;
        viewController.hidesBottomBarWhenPushed = YES;
        [naviVC pushViewController:viewController animated:YES];
    }
    
}

+ (void)pushViewController:(UIViewController *)viewController animate:(BOOL)animated{
    UIViewController *selectVC = [UIApplication sharedApplication].windows.lastObject.rootViewController;
    if ([selectVC isKindOfClass:[LWNavigationViewController class]]) {
        viewController.hidesBottomBarWhenPushed = YES;
        [(LWNavigationViewController *)selectVC pushViewController:viewController animated:animated];
    }else if ([selectVC isKindOfClass:[UITabBarController class]]){
        AppDelegate *appdelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LWNavigationViewController *naviVC = (LWNavigationViewController *)appdelete.tabBarVC.selectedViewController;
        viewController.hidesBottomBarWhenPushed = YES;
        [naviVC pushViewController:viewController animated:animated];
    }
}

+ (void)presentViewController:(UIViewController *)viewController animate:(BOOL)animated{
    
    [[LogicHandle topViewController] presentViewController:viewController animated:YES completion:nil];
    
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [[self class] _topViewController:[[UIApplication sharedApplication].windows.lastObject rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [[self class] _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[LWNavigationViewController class]]) {
        return [[self class] _topViewController:[(LWNavigationViewController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [[self class] _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (void)popToRootViewController{
//    LWNavigationViewController *selectVC = (LWNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [selectVC popToRootViewControllerAnimated:YES];
    [[self class] popToCurrentRootViewController];
}

+ (void)popToCurrentRootViewController{
    UIViewController *selectVC = [UIApplication sharedApplication].windows.lastObject.rootViewController;
    if ([selectVC isKindOfClass:[LWNavigationViewController class]]) {
        [(LWNavigationViewController *)selectVC popToRootViewControllerAnimated:YES];
    }else if ([selectVC isKindOfClass:[UITabBarController class]]){
        AppDelegate *appdelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LWNavigationViewController *naviVC = appdelete.tabBarVC.selectedViewController;
        [naviVC popToRootViewControllerAnimated:YES];
    }
}

+ (void)showLoginVC{
    LWLoginViewController *loginVC = [[LWLoginViewController alloc]initWithNibName:@"LWLoginViewController" bundle:nil];
    AppDelegate *appdelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelete.window.rootViewController = loginVC;
}

+ (void)showTabbarVC{
    LWTabBarViewController *tabBarVC = [[LWTabBarViewController alloc]init];
    AppDelegate *appdelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelete.window.rootViewController = tabBarVC;
}

@end
