//
//  LWMutipyWalletDetailListView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"
#import "LWHomeWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMultipyWalletDetailListView : LWBaseTableView

@property (nonatomic, strong) LWHomeWalletModel *homeWallteModel;

@property (nonatomic, assign) NSInteger walletId;
- (void)getCurrentData;

@end

NS_ASSUME_NONNULL_END
