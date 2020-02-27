//
//  LWMessageDetailViewController.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseViewController.h"
#import "LWHomeWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMessageDetailViewController : LWBaseViewController

/// 1个人钱包 2多人钱包
@property (nonatomic, assign) NSInteger detailViewType;
@property (nonatomic, strong) LWHomeWalletModel *contentModel;

@end

NS_ASSUME_NONNULL_END
