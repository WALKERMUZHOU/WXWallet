//
//  LWHomeListView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListView.h"

#import "LWHomeListCoordinator.h"
#import "LWHomeListCell.h"
#import "LWHomeWalletModel.h"
#import "LWHomeListHeaderView.h"

@interface LWHomeListView()<LWCoordinatorDelegate,MGSwipeTableCellDelegate>{
    NSIndexPath *_deleteIndexPath;
    NSInteger   _listType;
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
    _listType = 1;
    if (self) {
        self.currentViewType = WSRequestIdWalletQueryPersonalWallet;
        
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
        
    }
    return self;
}

- (void)loadDataWithPage:(NSUInteger)currentPage{

    
    if (currentPage) {
        self.currentPage = currentPage;
    }

    NSDictionary *paramers = @{@"pageNum":@(self.currentPage),@"pageSize":@(20)};
 //   [self.tableView reloadData];
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
        return YES;
    };
    cell.leftButtons = @[leftBtn];
    MGSwipeButton *rightBtn = [MGSwipeButton buttonWithTitle:@"收款" backgroundColor:lwColorNormalDeep];
    rightBtn.buttonWidth = 90;
    rightBtn.callback = ^BOOL(MGSwipeTableCell * _Nonnull cell) {
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
}

#pragma mark - celldelegate
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

//-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
//             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
//{
//
//    swipeSettings.transition = MGSwipeTransitionBorder;
//    expansionSettings.buttonIndex = 0;
//
//    if (direction == MGSwipeDirectionLeftToRight) {
//
//        expansionSettings.fillOnTrigger = NO;
//        expansionSettings.threshold = 2;
//
//        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        leftButton.frame = CGRectMake(0, 0, 100, 90);
//        [leftButton setTitle:@"转账" forState:UIControlStateNormal];
//        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [leftButton setBackgroundColor:lwColorNormal];
//        [leftButton.titleLabel setFont:kBoldFont(40)];
//        [leftButton addTarget:self action:@selector(transferAccount:) forControlEvents:UIControlEventTouchUpInside];
//        return @[leftButton];
//    }
//    else {
//
//        expansionSettings.fillOnTrigger = YES;
//        expansionSettings.threshold = 2;
//
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        rightButton.frame = CGRectMake(0, 0, 100, 90);
//        [rightButton setTitle:@"收款" forState:UIControlStateNormal];
//        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [rightButton setBackgroundColor:lwColorNormalDeep];
//        [rightButton.titleLabel setFont:kBoldFont(40)];
//        [rightButton addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
//
//        return @[rightButton];
//
//    }
//
//    return nil;
//
//}

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
        if (self.currentViewType == WSRequestIdWalletQueryPersonalWallet) {
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
        if (self.currentViewType == WSRequestIdWalletQueryMulpityWallet) {
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

- (void)collection:(UIButton *)sender{
    
}

- (void)transferAccount:(UIButton *)sender{
    
}
@end
