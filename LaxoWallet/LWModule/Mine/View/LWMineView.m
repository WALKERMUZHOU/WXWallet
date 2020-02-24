//
//  LWMineView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineView.h"

#import "LWMineHeaderView.h"
#import "LWMineTableViewCell.h"
#import "LWMineSecurityViewController.h"

@interface LWMineView ()

@property (nonatomic, strong) LWMineHeaderView *headerView;

@end

@implementation LWMineView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self setRefreshHeaderAndFooterNeeded:NO];
    if (@available(iOS 11.0, *)){
       self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
       self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);//导航栏如果使用系统原生半透明的，top设置为64
//       self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    UINib *nib1 = [UINib nibWithNibName:@"LWMineTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWMineTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.coordinator = [[LWHomeListCoordinator alloc]init];
//    self.coordinator.delegate = self;
//    _isCanApplyBorrow = YES;
    self.headerView = [[LWMineHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight + 100)];
    __weak typeof(self) weakSelf = self;
    self.tableView.tableHeaderView = self.headerView;
    
    NSArray *array = @[@{@"title":@"安全中心",@"type":@"1"},
                       @{@"title":@"支持",@"type":@"1"},
                       @{@"title":@"设置",@"type":@"1"},
                       @{@"title":@"备份图片",@"type":@"2"}];
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *infoDic = [self.dataSource objectAtIndex:indexPath.row];
    NSInteger type = [[infoDic objectForKey:@"type"] integerValue];
    LWMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWMineTableViewCell"];
    [cell setInfoDic:infoDic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LWMineSecurityViewController *securityVC = [[LWMineSecurityViewController alloc]init];
        securityVC.MineVCType = 1;
        [LogicHandle pushViewController:securityVC];
    }else if (indexPath.row == 2){
        LWMineSecurityViewController *securityVC = [[LWMineSecurityViewController alloc]init];
        securityVC.MineVCType = 2;
        [LogicHandle pushViewController:securityVC];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
