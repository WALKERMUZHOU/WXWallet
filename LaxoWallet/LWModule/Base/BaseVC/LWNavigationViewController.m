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
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_navi_Back"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = nil;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}
//                                                forState:UIControlStateNormal];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}
//                                                forState:UIControlStateHighlighted];
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_navilogo_bit"]];
    logoImageView.frame = CGRectMake(kScreenWidth/2 - 31, 3, 62, 62);
    [self.navigationBar addSubview:logoImageView];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"tableView willShow viewcontrollers %lu", [self viewControllers].count);
    
//    BOOL hiddenAnimate = NO;
//    NSInteger count = ((LWTabBarViewController *)viewController.tabBarController).axcTabBar.selectIndex;
////    NSLog(@"tableView willShow delayIndex %ld",(long)count);
//    if (count == 0) {
//        hiddenAnimate = YES;
//        BOOL isShowHomePage = [viewController isKindOfClass:[LWHomeViewController class]];
//        [self setNavigationBarHidden:isShowHomePage animated:hiddenAnimate];
//    }
//
//    if (count == 1) {
//        hiddenAnimate = YES;
//        BOOL isShowHomePage = [viewController isKindOfClass:[LWMineViewController class]];
//        [self setNavigationBarHidden:isShowHomePage animated:hiddenAnimate];
//    }

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
