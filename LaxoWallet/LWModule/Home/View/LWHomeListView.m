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
#import "LWHomeListModel.h"
#import "LWHomeListHeaderView.h"

@interface LWHomeListView()<LWCoordinatorDelegate,MGSwipeTableCellDelegate>{
    NSIndexPath *_deleteIndexPath;
    NSInteger   _listType;
    BOOL _isCanApplyBorrow;

}
@property (nonatomic, strong) LWHomeListCoordinator   *coordinator;
@property (nonatomic, strong) LWHomeListHeaderView   *headerView;

@end

@implementation LWHomeListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    _listType = 1;;
    if (self) {
        [self setRefreshHeaderAndFooterNeeded:YES];
        if (@available(iOS 11.0, *)){
                   self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                   self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);//导航栏如果使用系统原生半透明的，top设置为64
                   self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
               }
        
        UINib *nib1 = [UINib nibWithNibName:@"LWHomeListCell" bundle: nil];
        [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWHomeListCell"];
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        self.coordinator = [[LWHomeListCoordinator alloc]init];
        self.coordinator.delegate = self;
        _isCanApplyBorrow = YES;
        self.headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWHomeListHeaderView class]) owner:nil options:nil].lastObject;

        self.tableView.tableHeaderView = self.headerView;
        
    }
    return self;
}

- (void)loadDataWithPage:(NSUInteger)currentPage{

    
    if (currentPage) {
        self.currentPage = currentPage;
    }

    NSDictionary *paramers = @{@"pageNum":@(self.currentPage),@"pageSize":@(20)};
    [self.tableView reloadData];
//    if (_listType == 1) {
//        [self.coordinator getNewOrderListDataWithParamers:paramers];
//    }else{
//        [self.coordinator getOldOrderListDataWithParamers:paramers];
//    }
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWHomeListCell"];
    cell.delegate = self;
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

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    if (direction == MGSwipeDirectionLeftToRight) {
        
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 2;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftButton.frame = CGRectMake(0, 0, 100, 90);
        [leftButton setTitle:@"转账" forState:UIControlStateNormal];
        [leftButton setBackgroundColor:[UIColor greenColor]];
        
        return @[leftButton];
    }
    else {
        
        expansionSettings.fillOnTrigger = YES;
        expansionSettings.threshold = 2;

//        CGFloat padding = 15;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = CGRectMake(0, 0, 100, 90);
        [rightButton setTitle:@"收款" forState:UIControlStateNormal];
        [rightButton setBackgroundColor:[UIColor redColor]];
        
        return @[rightButton];
        
    }
    
    return nil;
    
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

@end
