//
//  LWMessageDeleteUserView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageDeleteUserView.h"
#import "LWMessageDeleteTableViewCell.h"

@implementation LWMessageDeleteUserView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self setRefreshHeaderAndFooterNeeded:NO];
    
    UINib *nib1 = [UINib nibWithNibName:@"LWMessageDeleteTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWMessageDeleteTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = lwColorBackground;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    UIButton *deleteBtn = [[UIButton alloc] init];
    deleteBtn.frame = CGRectMake(0, 40, 129, 39);
    deleteBtn.kcenterX = kScreenWidth/2;
    [deleteBtn setBackgroundColor:[UIColor hex:@"#FB7474"]];
    [deleteBtn.titleLabel setFont:kFont(17.5)];
    [deleteBtn setTitleColor:lwColorWhite forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deleteBtn];
    self.tableView.tableFooterView = bottomView;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageNotiData:) name:kWebScoket_getMessageListInfo object:nil];
//    [self getCurrentData];
}

//- (void)getCurrentData{
//    [SVProgressHUD show];
//    NSDictionary *multipyparams = @{@"type":@""};
//    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryGetWalletMessageList),@"wallet.query",[multipyparams jsonStringEncoded]];
//    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
//}
//
//- (void)manageNotiData:(NSNotification *)notification{
//    [SVProgressHUD dismiss];
//    NSDictionary *requestInfo = notification.object;
//    if ([[requestInfo objectForKey:@"success"]integerValue] == 1) {
//        NSArray *dataArray = [requestInfo objectForKey:@"data"];
//
//        NSArray *colorArray = @[[UIColor hex:@"#50E3C2"],
//        [UIColor hex:@"#DE7474"],
//        [UIColor hex:@"#D8D8D8"],
//        [UIColor hex:@"#478CC0"]];
//        if (dataArray.count>0) {
//            [self.dataSource removeAllObjects];
//            for (NSInteger i = 0; i<dataArray.count; i++) {
////                LWHomeWalletModel *model = [LWHomeWalletModel modelWithDictionary:dataArray[i]];
////                model.iconColor = (UIColor *)[colorArray objectAtIndex:i%colorArray.count];
////                [self.dataSource addObject:model];
//            }
//
////            NSArray *messageArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:dataArray];
////            [self.dataSource removeAllObjects];
////            [self.dataSource addObjectsFromArray:messageArray];
//            [self.tableView reloadData];
//        }
//    }
//}

#pragma mark - uitableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *messageModel = [self.dataSource objectAtIndex:indexPath.row];
    LWMessageDeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWMessageDeleteTableViewCell"];
    [cell setCellSelectBlock:^(BOOL isSelect) {
        
    }];
     
//    [cell setUserInfo:messageModel];
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
  
    
}

@end
