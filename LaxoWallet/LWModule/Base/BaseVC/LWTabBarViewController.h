//
//  LWTabBarViewController.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcAE_TabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWTabBarViewController : UITabBarController
@property(nonatomic, assign) NSInteger delayIndex;

@property (nonatomic, strong) AxcAE_TabBar *axcTabBar;

@end

NS_ASSUME_NONNULL_END
