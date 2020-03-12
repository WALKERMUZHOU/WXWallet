//
//  LWHomeListView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListView.h"
#import "LWHomeListCell.h"
#import "LWHomeListHeaderView.h"

#import "LWHomeListCoordinator.h"
#import "LWHomeWalletModel.h"

#import "LWPersonalTransferAccountViewController.h"
#import "LWPersonalCollectionViewController.h"
#import "LWMessageDetailViewController.h"

#import "LWAddressTool.h"
#import "LWSignTool.h"
#import "LWMultipySignTool.h"

@interface LWHomeListView()<LWCoordinatorDelegate,MGSwipeTableCellDelegate>{
    NSIndexPath *_deleteIndexPath;
    BOOL _isCanApplyBorrow;

}
@property (nonatomic, strong) LWHomeListCoordinator   *coordinator;
@property (nonatomic, strong) LWHomeListHeaderView   *headerView;
@property (nonatomic, strong) NSArray   *personalDataArray;
@property (nonatomic, strong) NSArray   *multipyDataArray;

@end

@implementation LWHomeListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    self.currentViewType = 1;
    if (self) {
        self.currentViewType = LWHomeListViewTypePersonalWallet;
        
        [self setRefreshHeaderAndFooterNeeded:NO];
        if (@available(iOS 11.0, *)){
           self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
           self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);//导航栏如果使用系统原生半透明的，top设置为64
           self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        }
        
        UINib *nib1 = [UINib nibWithNibName:@"LWHomeListCell" bundle: nil];
        [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWHomeListCell"];
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.coordinator = [[LWHomeListCoordinator alloc]init];
        self.coordinator.delegate = self;
        _isCanApplyBorrow = YES;
        self.headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWHomeListHeaderView class]) owner:nil options:nil].lastObject;
        self.headerView.currentType = LWHomeListViewTypePersonalWallet;
        __weak typeof(self) weakSelf = self;
        self.headerView.headerBlock = ^(NSInteger selectIndex) {
            [weakSelf changeCurrentSelectData:selectIndex];
        };
        self.tableView.tableHeaderView = self.headerView;
        [self initWsInfo];
    }
    return self;
}

- (void)initWsInfo{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSingleAddress:) name:kWebScoket_createSingleAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMultipyAddress:) name:kWebScoket_createSingleAddress object:nil];

}

#pragma mark - coordinator
- (void)coordinator:(LWBaseCoordinator *)coordinator data:(id)data{
    [self stopRefresh];
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [SVProgressHUD showErrorWithStatus:@"请求错误"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWHomeWalletModel *model = [self.dataSource objectAtIndex:indexPath.row];
    LWHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWHomeListCell"];
    cell.delegate = self;
    
    MGSwipeButton *leftBtn = [MGSwipeButton buttonWithTitle:@"转账" backgroundColor:lwColorNormal];
    leftBtn.buttonWidth = 90;
    leftBtn.callback = ^BOOL(MGSwipeTableCell * _Nonnull cell) {
        [self transferAccount:indexPath.row];
        return YES;
    };
    cell.leftButtons = @[leftBtn];
    MGSwipeButton *rightBtn = [MGSwipeButton buttonWithTitle:@"收款" backgroundColor:lwColorNormalDeep];
    rightBtn.buttonWidth = 90;
    rightBtn.callback = ^BOOL(MGSwipeTableCell * _Nonnull cell) {
        [self collection:indexPath.row];
        return YES;
    };
    cell.rightButtons = @[rightBtn];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
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

    LWHomeWalletModel *model = [self.dataSource objectAtIndex:indexPath.row];
    LWMessageDetailViewController *detailVC = [[LWMessageDetailViewController alloc] init];
    detailVC.contentModel = model;
    if (self.currentViewType == LWHomeListViewTypePersonalWallet) {
        detailVC.detailViewType = 1;
        detailVC.title = @"个人钱包";
        [LogicHandle pushViewController:detailVC];
    }else{
        detailVC.detailViewType = 2;
        detailVC.title = model.name;
        if (model.needToJoinCount == 0) {
            [LogicHandle pushViewController:detailVC];
            return;
        }
        [LogicHandle pushViewController:detailVC];
    }
}

#pragma mark - celldelegate
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString * str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}

#pragma mark - method
- (void)setPersonalWalletdData:(NSDictionary *)personalDic{
    NSArray *dataArray = [personalDic objectForKey:@"data"];
    if (dataArray.count>0) {
        self.personalDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:dataArray];
        [self.headerView setCurrentArray:self.personalDataArray];
        if (self.currentViewType == LWHomeListViewTypePersonalWallet) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:self.personalDataArray];
            [self.tableView reloadData];
        }
    }
}

- (void)setMultipyWalletdata:(NSDictionary *)multipyDic{
    NSArray *dataArray = [multipyDic objectForKey:@"data"];
    if (dataArray.count>0) {
        self.multipyDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:dataArray];
        if (self.currentViewType == LWHomeListViewTypeMultipyWallet) {
            [self.headerView setCurrentArray:self.multipyDataArray];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:self.multipyDataArray];
            [self.tableView reloadData];
        }
    }
}

- (void)changeCurrentSelectData:(NSInteger)selectIndex{
    self.currentViewType = selectIndex;
    [self.dataSource removeAllObjects];

    if (self.currentViewType == LWHomeListViewTypePersonalWallet) {
        [self.dataSource addObjectsFromArray:self.personalDataArray];
    }else{
        [self.dataSource addObjectsFromArray:self.multipyDataArray];
    }
    [self.headerView setCurrentArray:self.dataSource];
    [self.tableView reloadData];
}

- (void)collection:(NSInteger)index{

    if(self.currentViewType == LWHomeListViewTypePersonalWallet){
        
        LWHomeWalletModel *model = [self.dataSource objectAtIndex:index];
        NSString *address = [model.deposit objectForKey:@"address"];
#warning sign-code
//        LWSignTool *signtool = [LWSignTool shareInstance];
//        [signtool setWithAddress:address];
//        return;
        if (address && address.length >0) {
            LWPersonalCollectionViewController *personVC = [LWPersonalCollectionViewController shareInstanceWithCodeStr:address];
            [LogicHandle presentViewController:personVC animate:YES];
        }else{
            [self getQrCodeWithIndex:index];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getMulityQrCodeWithIndex:index];
        });

    }
}

#pragma mark - 个人钱包
- (void)getQrCodeWithIndex:(NSInteger)index{
    LWHomeWalletModel *model = [self.dataSource objectAtIndex:index];
    NSDictionary *params = @{@"wid":@(model.walletId)};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQuerySingleAddress),@"wallet.createSingleAddress",[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)createSingleAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSString *rid = [[notiDic objectForKey:@"data"] objectForKey:@"rid"];
        NSString *path = [[notiDic objectForKey:@"data"] objectForKey:@"path"] ;

        [SVProgressHUD show];
        LWAddressTool *addressTool = [LWAddressTool shareInstance];
        [addressTool setWithrid:rid andPath:path];
        addressTool.addressBlock = ^(NSString * _Nonnull address) {
            [SVProgressHUD dismiss];
            
            //刷新下首页个人钱包数据
            NSDictionary *params = @{@"type":@1};
            NSArray *requestPersonalWalletArray = @[@"req",
                                                    @(WSRequestIdWalletQueryPersonalWallet),
                                                    @"wallet.query",
                                                    [params jsonStringEncoded]];
            NSData *data = [requestPersonalWalletArray mp_messagePack];
            [[SocketRocketUtility instance] sendData:data];

            LWPersonalCollectionViewController *personVC = [LWPersonalCollectionViewController shareInstanceWithCodeStr:address];
            [LogicHandle presentViewController:personVC animate:YES];
        };
    }
}

- (void)transferAccount:(NSInteger)index{
    LWHomeWalletModel *model = [self.dataSource objectAtIndex:index];
    NSString *address = [model.deposit objectForKey:@"address"];
    if (address && address.length >0) {
        LWPersonalTransferAccountViewController *personalTA = [[LWPersonalTransferAccountViewController alloc]init];
        [personalTA setModel:model];
        [LogicHandle presentViewController:personalTA animate:YES];
    }else{
        [self getQrCodeWithIndex:index];
    }
}

#pragma mark - 多人钱包

- (void)getMulityQrCodeWithIndex:(NSInteger)index{
    LWHomeWalletModel *model = [self.dataSource objectAtIndex:index];
    NSDictionary *params = @{@"wid":@(model.walletId)};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQueryMultipyAddress),WS_Home_getMutipyAddress,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];

}

- (void)createMultipyAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSString *rid = [[notiDic objectForKey:@"data"] objectForKey:@"rid"];
        NSString *path = [[notiDic objectForKey:@"data"] objectForKey:@"path"] ;

        [SVProgressHUD show];
    //    LWMultipySignTool *addressTool = [[LWMultipySignTool alloc] initWithInitInfo:[notiDic objectForKey:@"data"]];
//        [addressTool setWithrid:rid andPath:path];
//        addressTool.addressBlock = ^(NSString * _Nonnull address) {
//            [SVProgressHUD dismiss];
//
//
//        };
    }
    
}
@end
