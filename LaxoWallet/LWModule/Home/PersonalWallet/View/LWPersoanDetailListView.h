//
//  LWPersoanDetailListView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"
#import "LWHomeWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWPersoanDetailListView : LWBaseTableView
@property (nonatomic, assign) NSInteger walletId;
@property (nonatomic, strong) LWHomeWalletModel *homeWallteModel;

- (void)getCurrentData;
@end

NS_ASSUME_NONNULL_END
