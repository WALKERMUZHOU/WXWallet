//
//  LWMutipyWalletDetailListView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyWalletDetailListView.h"
#import "LWMultipyBeInvitedViewController.h"

#import "LWMessageModel.h"
#import "LWPersonalListTableViewCell.h"
#import "LWMultipyWalletDetailCell.h"
#import "LWAlertTool.h"

@implementation LWMultipyWalletDetailListView{
    dispatch_source_t _timer;
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentData) name:kWebScoket_Multipy_refrshWalletDetail object:nil];

}

- (void)getCurrentData{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(self.walletId)};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMessageListInfo),WS_Home_MessageList,[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)manageMessageListData:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    [self.dataSource removeAllObjects];
    NSDictionary *requestInfo = notification.object;
    if ([[requestInfo objectForKey:@"success"]integerValue] == 1) {
        NSArray *dataArray = [[requestInfo objectForKey:@"data"] objectForKey:@"rows"];
        for (NSInteger i = 0; i<dataArray.count; i++) {
            LWMessageModel *model = [LWMessageModel modelWithDictionary:dataArray[i]];
            [self.dataSource addObj:model];
        }
        [self.tableView reloadData];
    }
    
    NSInteger flag = 1;
    for (NSInteger i = 0; i<self.dataSource.count; i++) {
        LWMessageModel *messageModel = [self.dataSource objectAtIndex:i];
        if (messageModel.status == 1) {
            NSArray *approveArray = [messageModel.user_status objectForKey:@"approve"];
            if (approveArray && approveArray.count == self.homeWallteModel.threshold) {
                if(_timer) return;
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(_timer, ^{
                    [self broadCastNeedSign];
                });
                dispatch_resume(_timer);
                flag = 0;
                return;
            }
        }
    }
    
    if(_timer){
        dispatch_cancel(_timer);
        _timer = nil;
    }
    
}

- (void)broadCastNeedSign{
    NSDictionary *multipyparams = @{@"wid":@(self.walletId)};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWallet_multipy_checkPendingTransaction),@"wallet.checkPendingTransaction",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
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
            [cell setCotentmodel:self.homeWallteModel];
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
    
    LWMessageModel *messageModel = [self.dataSource objectAtIndex:indexPath.section];
    
    if(messageModel.type == 1){
        [LWAlertTool alertReceiveddAlertView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
            
        }];
    }else{
        
        if (messageModel.status == 1) {
            NSDictionary *userStatues = messageModel.user_status;
            NSArray *approve = [userStatues objectForKey:@"approve"];
            NSArray *reject = [userStatues objectForKey:@"reject"];
            
            if (messageModel.isMineCreateTrans) {
                if (approve.count == 0 || approve.count == 1) {//outgoing
                    [LWAlertTool alertMultipyOutgoingView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                        
                    }];
                    
                }else{// you unSigned / you signed

                    NSInteger ismineSigned = 0;
                    for (NSInteger i = 0; i<approve.count; i++) {
                        NSString *approveID = [NSString stringWithFormat:@"%@",approve[i]];
                        if ([approveID isEqualToString:[[LWUserManager shareInstance] getUserModel].uid]) {
                            ismineSigned = 1;
                            break;
                        }
                    }
                    
                    if (ismineSigned == 1 && approve.count == 1) {
                        [LWAlertTool alertMultipyOutgoingView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                                  
                        }];
                        
                    }else if(ismineSigned == 1){
                        [LWAlertTool alertMultipySignedView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                                                          
                                                    
                                    }];
                    }else{//
            
                        [LWAlertTool alertMultipyPendingView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                                             
                                   }];
                    }
                    
                }
            }else{
                if (approve.count == 0) {//outgoing
                    [LWAlertTool alertMultipyPendingView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                
                    }];
                    
                 }else{// you unSigned / you signed
                     
                     NSInteger ismineSigned = 0;
                     for (NSInteger i = 0; i<approve.count; i++) {
                         NSString *approveID = [NSString stringWithFormat:@"%@",approve[i]];
                         if ([approveID isEqualToString:[[LWUserManager shareInstance] getUserModel].uid]) {
                             ismineSigned = 1;
                             break;
                         }
                     }
                     
                     if (ismineSigned == 1) {
                         [LWAlertTool alertMultipySignedView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                                                    
                                              
                        }];
                         
                     }else{//
                         [LWAlertTool alertMultipyPendingView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                                     
                           }];
                     }
                     
                 }
            }
            
        }else if(messageModel.status == 2){
            [LWAlertTool alertSendAlertView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                        
              }];

            
        }else if(messageModel.status == 3){
            [LWAlertTool alertMultipyCancleView:self.homeWallteModel andMessageModel:messageModel andComplete:^(id  _Nonnull complete) {
                
            }];
        }
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
