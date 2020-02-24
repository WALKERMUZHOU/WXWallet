//
//  LWNavigationViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWNavigationViewController.h"
#import "LWTabBarViewController.h"
#import "LWHomeViewController.h"
#import "LWMineViewController.h"
@interface LWNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation LWNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"tableView willShow viewcontrollers %lu", [self viewControllers].count);
    
    
    BOOL hiddenAnimate = NO;
    NSInteger count = ((LWTabBarViewController *)viewController.tabBarController).axcTabBar.selectIndex;
//    NSLog(@"tableView willShow delayIndex %ld",(long)count);
    if (count == 0) {
        hiddenAnimate = YES;
        BOOL isShowHomePage = [viewController isKindOfClass:[LWHomeViewController class]];
        [self setNavigationBarHidden:isShowHomePage animated:hiddenAnimate];
    }
    
    if (count == 2) {
        hiddenAnimate = YES;
        BOOL isShowHomePage = [viewController isKindOfClass:[LWMineViewController class]];
        [self setNavigationBarHidden:isShowHomePage animated:hiddenAnimate];
    }

}


//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (viewController.tabBarController.selectedIndex == 0 && [self.viewControllers count] > 1) {
//        ((LWTabBarViewController *)viewController.tabBarController).delayIndex = viewController.tabBarController.selectedIndex;
//
//    }
//    NSLog(@"tableView didShow viewcontrollers %lu", [self viewControllers].count);
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
