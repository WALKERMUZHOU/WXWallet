//
//  LWPaymialListTableView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPaymialListTableView.h"
#import "LWPaymailModel.h"
#import "LWPaymailTableViewCell.h"

@implementation LWPaymialListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self setRefreshHeaderAndFooterNeeded:NO];

    UINib *nib1 = [UINib nibWithNibName:@"LWPaymailTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWPaymailTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSatue:) name:kWebScoket_userIsOnLine object:nil];
    [self getCurrentPaymailSatue];
}



- (void)getCurrentPaymailSatue{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(self.model.walletId)};
      NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestId_paymail_queryByWid),WS_paymail_queryByWid,[multipyparams jsonStringEncoded]];
      [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)getUserSatue:(NSNotification *)notification{
    NSDictionary *resInfo = notification.object;
     if ([[resInfo objectForKey:@"success"] integerValue] == 1) {
         NSArray *statueArray = [resInfo objectForKey:@"data"];
         
         if (statueArray.count == 0) {
             LWPaymailModel *model = [[LWPaymailModel alloc] init];
             [self.dataSource addObj:model];
         }else{
             [self.dataSource addObjectsFromArray:[NSArray modelArrayWithClass:[LWPaymailModel class] json:statueArray]];
         }
         
         [self.tableView reloadData];
         
     }else{
         NSString *message = [resInfo objectForKey:@"message"];
         if (message && message.length>0) {
             [WMHUDUntil showMessageToWindow:message];
         }
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
    LWPaymailModel *messageModel = [self.dataSource objectAtIndex:indexPath.section];
    LWPaymailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWPaymailTableViewCell"];
    cell.model = messageModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
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
