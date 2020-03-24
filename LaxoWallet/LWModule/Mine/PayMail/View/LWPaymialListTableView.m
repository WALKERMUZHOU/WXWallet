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
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib1 = [UINib nibWithNibName:@"LWPaymailTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWPaymailTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSatue:) name:kWebScoket_paymail_queryByWid object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setmain:) name:kWebScoket_paymail_setMain object:nil];

    
//    [self getCurrentPaymailSatue];
}

- (void)setModel:(LWHomeWalletModel *)model{
    _model = model;
    [self getCurrentPaymailSatue];
}

#pragma mark - listdata
- (void)getCurrentPaymailSatue{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(self.model.walletId)};
      NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestId_paymail_queryByWid),WS_paymail_queryByWid,[multipyparams jsonStringEncoded]];
      [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)getUserSatue:(NSNotification *)notification{
    [self.dataSource removeAllObjects];
    NSDictionary *resInfo = notification.object;
     if ([[resInfo objectForKey:@"success"] integerValue] == 1) {
         NSArray *statueArray = [resInfo objectForKey:@"data"];
         if (self.block) {
             self.block(statueArray.count);
         }
         
         for (NSInteger i = 0; i<statueArray.count; i++) {
             LWPaymailModel *model = [LWPaymailModel modelWithDictionary:statueArray[i]];
             model.index = i;
             if (model.main == 1) {
                 [self.dataSource insertObject:model atIndex:0];
                 for (NSInteger j = 0; j<self.dataSource.count; j++) {
                      LWPaymailModel *model = self.dataSource[j];
                      model.index = j;
                  }
             }else{
                 [self.dataSource addObj:model];
             }
         }
         [self.tableView reloadData];
         
     }else{
         NSString *message = [resInfo objectForKey:@"message"];
         if (message && message.length>0) {
             [WMHUDUntil showMessageToWindow:message];
         }
     }
}

#pragma mark - setmain
- (void)setMain:(NSString *)paymaiID{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(self.model.walletId),@"uid":[[LWUserManager shareInstance] getUserModel].uid,@"id":paymaiID};
      NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestId_paymail_setMain),WS_paymail_setMain,[multipyparams jsonStringEncoded]];
      [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)setmain:(NSNotification *)notification{
    [self.dataSource removeAllObjects];
    NSDictionary *resInfo = notification.object;
     if ([[resInfo objectForKey:@"success"] integerValue] == 1) {
         [self getCurrentPaymailSatue];
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
    cell.block = ^(NSString * _Nonnull paymailID) {
        [SVProgressHUD show];
        [self setMain:paymailID];
    };
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
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.f;
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
