//
//  LWSendCheckViewController.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseViewController.h"
#import "LWTransactionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWSendCheckViewController : LWBaseViewController

@property (nonatomic, strong) LWTransactionModel *model;
@property (nonatomic, strong) LWHomeWalletModel *walletModel;

@end

NS_ASSUME_NONNULL_END
