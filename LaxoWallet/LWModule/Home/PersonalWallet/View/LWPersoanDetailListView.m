//
//  LWPersoanDetailListView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersoanDetailListView.h"

#import "LWMessageModel.h"
#import "LWPersonalListTableViewCell.h"

@implementation LWPersoanDetailListView

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
//       self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//    }
    UINib *nib1 = [UINib nibWithNibName:@"LWPersonalListTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWPersonalListTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageMessageListData:) name:kWebScoket_messageListInfo object:nil];
}

- (void)getCurrentData{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(self.walletId)};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMessageListInfo),WS_Home_MessageList,[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)manageMessageListData:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    NSDictionary *requestInfo = notification.object;
    if ([[requestInfo objectForKey:@"success"]integerValue] == 1) {
        NSArray *dataArray = [[requestInfo objectForKey:@"data"] objectForKey:@"rows"];
        for (NSInteger i = 0; i<dataArray.count; i++) {
            LWMessageModel *model = [LWMessageModel modelWithDictionary:dataArray[i]];
            [self.dataSource addObj:model];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - uitableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWMessageModel *messageModel = [self.dataSource objectAtIndex:indexPath.section];
    LWPersonalListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWPersonalListTableViewCell"];
    [cell setModel:messageModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.0001)];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
