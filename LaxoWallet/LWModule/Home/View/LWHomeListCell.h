//
//  LWHomeListCell.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "MGSwipeTableCell.h"
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWHomeListCell : MGSwipeTableCell

@property (nonatomic, strong) LWHomeWalletModel *model;

@end

NS_ASSUME_NONNULL_END
