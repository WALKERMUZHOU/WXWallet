//
//  LWBaseView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWBaseCoordinator.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWBaseView : UIView<LWCoordinatorDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) NSUInteger currentPage;
@property (assign, nonatomic) NSUInteger totalPage;
@property (assign, nonatomic) BOOL refreshHeaderAndFooterNeeded;
@property (assign, nonatomic) BOOL refreshFooterNeeded;
@property(nonatomic,copy)NSString *scrollReuseIdentifier;

@property (nonatomic, strong) NSString *noMoreDataFooterState;//自定义底部无数据文案

// default is No

- (void)refreshWithHeader;
- (void)loadView;
#pragma mark - refresh
- (void)loadDataWithPage:(NSUInteger)currentPage;
- (void)stopRefresh;
- (void)noMoreData;
#pragma mark - setListView
- (UIScrollView *)getListView;

@end

NS_ASSUME_NONNULL_END
