//
//  LWSignStatueListView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSignStatueListView.h"
#import "LWSignSatueTableViewCell.h"
#import "LWSignStatueModel.h"
#import "LWSignStauteBottomView.h"
@implementation LWSignStatueListView{
    LWSignStauteBottomView *_walletBottomView;
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib1 = [UINib nibWithNibName:@"LWSignSatueTableViewCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWSignSatueTableViewCell"];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSatue:) name:kWebScoket_userIsOnLine object:nil];
    
    _walletBottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWSignStauteBottomView class]) owner:nil options:nil].lastObject;
    self.tableView.tableFooterView = _walletBottomView;
}

- (void)setSignessSatuteViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel{
    [self.dataSource removeAllObjects];
    
    for (NSInteger i = 0; i<walletModel.parties.count; i++) {
        LWPartiesModel *partiesModel = walletModel.parties[i];
        
        LWSignStatueModel *model = [[LWSignStatueModel alloc] init];
        model.index = i+1;
        model.email = partiesModel.user;
        model.uid = partiesModel.uid;
        
        if (messageModel) {
               NSDictionary *statueDic = messageModel.user_status;
               NSArray *approve = [statueDic objectForKey:@"approve"];
               for (NSInteger i = 0; i<approve.count; i++) {
                   NSString *uid = [NSString stringWithFormat:@"%@", [approve objectAtIndex:i]];
        
                   if ([uid isEqualToString:partiesModel.uid]) {
                       model.currentStatue = 1;
                       break;
                   }
               }
        }else{
            model.isUserStatueView = YES;
            _walletBottomView.isHiddenBtn = YES;
        }
        

        [self.dataSource addObj:model];
    }
    
    [self.tableView reloadData];
    [self getCurrentUserSatue];
}

- (void)getCurrentUserSatue{
    for (NSInteger i = 0; i<self.dataSource.count; i++) {
        LWSignStatueModel *model = [self.dataSource objectAtIndex:i];
//        if ([model.uid isEqualToString:[[LWUserManager shareInstance]getUserModel].uid]) {
//            continue;
//        }
        NSDictionary *multipyparams = @{@"uid":model.uid};
        NSString *idstring = [NSString stringWithFormat:@"20000%@",model.uid];
        NSArray *requestmultipyWalletArray = @[@"req",idstring,WS_Home_UserIsOnLine,[multipyparams jsonStringEncoded]];
        [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    }
}

- (void)getUserSatue:(NSNotification *)notification{
    NSDictionary *resInfo = notification.object;
     if ([[resInfo objectForKey:@"success"] integerValue] == 1) {
         NSArray *statueArray = [resInfo objectForKey:@"data"];
         NSInteger statue = [[statueArray objectAtIndex:0] integerValue];
         NSString *uid =[NSString stringWithFormat:@"%@",[resInfo objectForKey:@"uid"]];
         uid = [uid stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
         for (NSInteger i = 0; i<self.dataSource.count; i++) {
             LWSignStatueModel *model = [self.dataSource objectAtIndex:i];
             if ([uid isEqualToString:model.uid]) {
                 model.isOnLine = statue;
                [self.tableView reloadSection:i withRowAnimation:UITableViewRowAnimationFade];
                 return;
             }
         }
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
    LWSignStatueModel *messageModel = [self.dataSource objectAtIndex:indexPath.section];    
    LWSignSatueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWSignSatueTableViewCell"];
    cell.stauteModel = messageModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
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
