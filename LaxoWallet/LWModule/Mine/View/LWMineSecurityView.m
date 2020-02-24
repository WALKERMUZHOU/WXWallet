//
//  LWMineSecurityView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineSecurityView.h"
#import "LWMineSecurityTableViewCell.h"
@implementation LWMineSecurityView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self setRefreshHeaderAndFooterNeeded:NO];
//    if (@available(iOS 11.0, *)){
//       self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//       self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);//导航栏如果使用系统原生半透明的，top设置为64
////       self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//    }
    
    UINib *nib1 = [UINib nibWithNibName:@"LWMineSecurityTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWMineSecurityTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *mailStr = [[LWUserManager shareInstance] getUserModel].email;
    
    NSArray *array = @[@{@"title":@"Trusthold备份",@"type":@"刚刚同步"},
                       @{@"title":@"邮箱已验证",@"type":@"36153297@qq.com"},
                       @{@"title":@"人脸识别已开启",@"type":@"确保只有本人授权动用资金"},
                       ];
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
    LWMineSecurityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWMineSecurityTableViewCell"];
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
}
@end
