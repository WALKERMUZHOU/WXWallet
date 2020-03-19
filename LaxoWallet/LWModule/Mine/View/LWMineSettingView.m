//
//  LWMineSettingView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineSettingView.h"
#import "LWMineTableViewCell.h"
#import "LWMineSecurityViewController.h"
#import "LWCommonBottomBtn.h"
@implementation LWMineSettingView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSourceChage) name:kCurrencyChange_nsnotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSourceChage) name:kLanguageChange_nsnotification object:nil];

    
    [self setRefreshHeaderAndFooterNeeded:NO];
    
    UINib *nib1 = [UINib nibWithNibName:@"LWMineTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWMineTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    LWCommonBottomBtn *bottomBtn = [[LWCommonBottomBtn alloc]init];
    bottomBtn.frame = CGRectMake(20, 50, kScreenWidth - 40, 50);
    [bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    bottomBtn.selected = YES;
    [bottomView addSubview:bottomBtn];
    self.tableView.tableFooterView = bottomView;
    
//    self.coordinator = [[LWHomeListCoordinator alloc]init];
//    self.coordinator.delegate = self;
//    _isCanApplyBorrow = YES;
    [self dataSourceChage];

    
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
    LWMineSecurityViewController *securityVC = [[LWMineSecurityViewController alloc]init];
    if (indexPath.row == 0) {
        securityVC.MineVCType = 3;
    }else{
        securityVC.MineVCType = 4;
    }
    [LogicHandle pushViewController:securityVC];

}

#pragma mark - method
- (void)dataSourceChage{
    if (self.dataSource) {
        [self.dataSource removeAllObjects];
    }
    NSString *currency ;
    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
        currency = @"CNY";
    }else{
        currency = @"USD";
    }
    NSString *language ;
    if ([LWPublicManager getCurrentLanguage] == LWCurrentLanguageChinese) {
        language = @"中文";
    }else{
        language = @"English";
    }
    
    NSArray *array = @[@{@"title":@"货币单位",@"type":@"3",@"content":currency},
                       @{@"title":@"语言",@"type":@"3",@"content":language}
                       ];
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (void)bottomClick:(UIButton *)sender{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"注意" message:@"您确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SocketRocketUtility instance] SRWebSocketClose];
        [[LWUserManager shareInstance] clearUser];
        [LogicHandle showLoginVC];
    }];
    [alertCon addAction:action];
    [alertCon addAction:actionSure];
    [LogicHandle presentViewController:alertCon animate:YES];
    
}

@end
