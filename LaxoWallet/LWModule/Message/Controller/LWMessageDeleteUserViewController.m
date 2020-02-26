//
//  LWMessageDeleteUserViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageDeleteUserViewController.h"
#import "LWMessageDeleteUserView.h"

@interface LWMessageDeleteUserViewController ()

@end

@implementation LWMessageDeleteUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LWMessageDeleteUserView *messageView = [[LWMessageDeleteUserView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, KScreenHeightBar - kTabBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:messageView];
    
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
