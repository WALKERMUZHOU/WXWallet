//
//  LWMessageDetailListView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMessageDetailListView : LWBaseTableView

@property (nonatomic, assign) NSInteger walletId;
- (void)getCurrentData;
@end

NS_ASSUME_NONNULL_END
