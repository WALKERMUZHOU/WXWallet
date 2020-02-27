//
//  LWMessageDetailListView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TableViewScrollingBlock)(void);
@interface LWMessageDetailListView : LWBaseTableView

@property (nonatomic, assign) NSInteger walletId;
@property (nonatomic, copy) TableViewScrollingBlock scrollBlock;

- (void)getCurrentData;
@end

NS_ASSUME_NONNULL_END
