//
//  LogicHandle.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/6.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogicHandle : NSObject
+ (void)pushViewController:(UIViewController *)viewController;

+ (void)pushViewController:(UIViewController *)viewController animate:(BOOL)animated;

+ (void)presentViewController:(UIViewController *)viewController animate:(BOOL)animated;
+ (void)naviPresentViewcontroller:(UIViewController *)viewController;
+ (void)popToRootViewController;

+ (void)popToCurrentRootViewController;

+ (void)showLoginVC;
+ (void)showTabbarVC;
+ (void)chooseStartVC;
@end

NS_ASSUME_NONNULL_END
