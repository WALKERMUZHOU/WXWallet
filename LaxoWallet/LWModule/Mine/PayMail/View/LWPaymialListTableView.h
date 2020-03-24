//
//  LWPaymialListTableView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^PayMailCountBlock)(NSInteger count);
@interface LWPaymialListTableView : LWBaseTableView

@property (nonatomic, strong) LWHomeWalletModel *model;
@property (nonatomic, copy) PayMailCountBlock block;

- (void)getCurrentPaymailSatue;
@end

NS_ASSUME_NONNULL_END
