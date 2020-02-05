//
//  LWBaseView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"

#import "CZRefreshHeader.h"
#import "CZRefreshFooter.h"
@interface LWBaseView ()

@property (weak, nonatomic) UIScrollView *listView;

@end

@implementation LWBaseView

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)loadView {
    
}

#pragma mark - Refresh and LoadMore

- (void)setRefreshHeaderAndFooterNeeded:(BOOL)refeshHeaderAndFooterNeeded {
    _refreshHeaderAndFooterNeeded = refeshHeaderAndFooterNeeded;
    if (!self.listView) {
        self.listView = [self getListView];
    }
    if (refeshHeaderAndFooterNeeded) {
        self.listView.mj_header.hidden = NO;
        self.listView.mj_header = [CZRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        self.listView.mj_footer.hidden = NO;
        self.listView.mj_footer = [CZRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }else{
        self.listView.mj_header.hidden = YES;
        self.listView.mj_footer.hidden = YES;
    }
}

- (void)setRefreshFooterNeeded:(BOOL)refreshFooterNeeded{
    _refreshFooterNeeded = refreshFooterNeeded;
    if (!self.listView) {
        self.listView = [self getListView];
    }
    if (refreshFooterNeeded) {
        self.listView.mj_header.hidden = YES;
        self.listView.mj_footer.hidden = NO;
        self.listView.mj_footer = [CZRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }else{
        self.listView.mj_footer.hidden = YES;
    }
}

- (void)refresh {
    self.currentPage = 1;
    [self.listView.mj_footer resetNoMoreData];
    [self loadDataWithPage:self.currentPage];
}

- (void)refreshWithHeader {
    [self.listView.mj_header beginRefreshing];
}

- (void)loadMore {
    self.currentPage ++ ;
    [self loadDataWithPage:self.currentPage];
}

- (void)loadDataWithPage:(NSUInteger)currentPage {
    
}

- (void)stopRefresh {
    [self.listView.mj_header endRefreshing];
    [self.listView.mj_footer endRefreshing];

}

- (void)noMoreData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listView.mj_footer endRefreshingWithNoMoreData];
    });
}

- (void)setNoMoreDataFooterState:(NSString *)noMoreDataFooterState{
    CZRefreshFooter *footer = [CZRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.normoreDataStr = noMoreDataFooterState;
    self.listView.mj_footer = footer;
    
}

#pragma mark - coordinatorDelegate

- (void)coordinatorBegainRequest {
    
}

- (void)coordinatorEndRequest {
    [self stopRefresh];
}

- (void)coordinator:(LWBaseCoordinator *)coordinator data:(id)data {
    if ([data isKindOfClass:[NSArray class]]) {
        if (self.currentPage == 1) {
         
            
            [self.dataSource removeAllObjects];
        }
        [self.dataSource addObjectsFromArray:(NSArray *)data
         ];
    }
}

#pragma mark - setListView
- (UIScrollView *)getListView {
    return nil;
}

@end
