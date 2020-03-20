//
//  LWMutipyWalletDetailListView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyWalletDetailListView.h"

#import "LWMessageModel.h"
#import "LWPersonalListTableViewCell.h"
#import "LWMultipyWalletDetailCell.h"

@implementation LWMultipyWalletDetailListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self setRefreshHeaderAndFooterNeeded:NO];

    UINib *nib1 = [UINib nibWithNibName:@"LWPersonalListTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWPersonalListTableViewCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"LWMultipyWalletDetailCell" bundle: nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"LWMultipyWalletDetailCell"];
    
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
    
    if(messageModel.type == 1){
        LWPersonalListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWPersonalListTableViewCell"];
        [cell setModel:messageModel];
        return cell;
    }else{
        
        if (messageModel.status == 3) {
            LWPersonalListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWPersonalListTableViewCell"];
            [cell setModel:messageModel];
            return cell;
        }else{
            LWMultipyWalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWMultipyWalletDetailCell"];
            [cell setModel:messageModel];
            return cell;
        }
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWMessageModel *messageModel = [self.dataSource objectAtIndex:indexPath.section];
    if(messageModel.type == 1){
        return 50.f;
    }else{
        if (messageModel.status == 3) {
         return 50.f;

           }else{
               return 70.f;
           }
    }
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
