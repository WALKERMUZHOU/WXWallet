//
//  LWMessageTableView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageTableView.h"
#import "LWHomeWalletModel.h"
#import "LWMessageTableViewCell.h"
#import "LWMessageDetailViewController.h"

@implementation LWMessageTableView

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
       self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    UINib *nib1 = [UINib nibWithNibName:@"LWMessageTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWMessageTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = lwColorBackground;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageNotiData:) name:kWebScoket_getMessageListInfo object:nil];
//    [self getCurrentData];
}

- (void)getCurrentData{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"type":@""};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryGetWalletMessageList),@"wallet.query",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)manageNotiData:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    NSDictionary *requestInfo = notification.object;
    if ([[requestInfo objectForKey:@"success"]integerValue] == 1) {
        NSArray *dataArray = [requestInfo objectForKey:@"data"];
        
        NSArray *colorArray = @[[UIColor hex:@"#50E3C2"],
        [UIColor hex:@"#DE7474"],
        [UIColor hex:@"#D8D8D8"],
        [UIColor hex:@"#478CC0"]];
        if (dataArray.count>0) {
            [self.dataSource removeAllObjects];
            for (NSInteger i = 0; i<dataArray.count; i++) {
                LWHomeWalletModel *model = [LWHomeWalletModel modelWithDictionary:dataArray[i]];
                model.iconColor = (UIColor *)[colorArray objectAtIndex:i%colorArray.count];
                [self.dataSource addObject:model];
            }
            
//            NSArray *messageArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:dataArray];
//            [self.dataSource removeAllObjects];
//            [self.dataSource addObjectsFromArray:messageArray];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - uitableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWHomeWalletModel *messageModel = [self.dataSource objectAtIndex:indexPath.row];
    LWMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWMessageTableViewCell"];
    [cell setModel:messageModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }else{
        return 0.0001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LWMessageDetailViewController *messagedetailVC = [[LWMessageDetailViewController alloc] init];
    [LogicHandle pushViewController:messagedetailVC];
}

@end
