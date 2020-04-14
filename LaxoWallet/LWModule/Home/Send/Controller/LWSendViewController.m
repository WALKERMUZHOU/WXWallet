//
//  LWSendViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSendViewController.h"
#import "LWSendAddressViewController.h"
#import "LWSendAmountViewController.h"
#import "LWSendCheckViewController.h"
#import "LWPageControl.h"
@interface LWSendViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController  *pageViewController;
@property (nonatomic, strong) NSMutableArray  *dataSource;

@end

@implementation LWSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}

- (void)createUI{
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
        
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    self.pageViewController.doubleSided = NO;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self.view);
    }];
    
    for (int i = 0; i < 3; i++) {
        [self.dataSource addObject:[self createViewController:i]];
    }
    
    //首页的效果
    [self.pageViewController setViewControllers:@[self.dataSource[0]]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:nil];
}

- (UIViewController *)createViewController:(NSInteger)index{
    if (index == 0) {
        LWSendAddressViewController *addressVC = [[LWSendAddressViewController alloc] init];
        return addressVC;
    }else if (index == 1){
        LWSendAmountViewController *amountVC = [[LWSendAmountViewController alloc] init];
        return amountVC;
    }else{
        LWSendCheckViewController *checkVC = [[LWSendCheckViewController alloc] init];
        return checkVC;
    }
}

- (nullable UIViewController *) pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    NSInteger index = [self.dataSource indexOfObject:viewController];
    index ++;
    if (index == self.dataSource.count ) {
        return nil;
    }
    
    return [self.dataSource objectAtIndex:index];
}

-(nullable UIViewController *) pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSInteger index = [self.dataSource indexOfObject:viewController];
    index --;
    if (index < 0) {
        return nil;
    }
    
    return [self.dataSource objectAtIndex:index];
}
   
//-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return self.dataSource.count;
//}

//返回页控制器中当前页的索引
//-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

- (UIPageViewControllerSpineLocation) pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    return UIPageViewControllerSpineLocationMin;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    NSLog(@"将要翻页也就是手势触发时调用方法");
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
