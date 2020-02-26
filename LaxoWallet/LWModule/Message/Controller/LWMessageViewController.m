//
//  LWMessageViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageViewController.h"
#import "LWMessageTableView.h"
#import "LWMessageMulpityHeadView.h"

@interface LWMessageViewController ()

@property (nonatomic, strong) LWMessageTableView *messageView;
@property (nonatomic, strong) LWMessageMulpityHeadView *headView;

@end

@implementation LWMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageView = [[LWMessageTableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, KScreenHeightBar - kTabBarHeight) style:UITableViewStyleGrouped];
    self.messageView.backgroundColor = lwColorBackground;
    [self.view addSubview:self.messageView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.messageView getCurrentData];
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
