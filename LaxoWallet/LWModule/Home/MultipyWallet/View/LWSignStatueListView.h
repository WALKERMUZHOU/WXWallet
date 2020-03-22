//
//  LWSignStatueListView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"
#import "LWHomeWalletModel.h"
#import "LWMessageModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^SignCloseBlock)(void);

@interface LWSignStatueListView : LWBaseTableView


- (void)setSignessSatuteViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel;
@property (nonatomic, copy) SignCloseBlock block;

@end

NS_ASSUME_NONNULL_END
