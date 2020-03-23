//
//  LWMultipyEditViewController.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseViewController.h"
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^EditViewBlock)(NSString *walletName);
@interface LWMultipyEditViewController : LWBaseViewController
@property (nonatomic, strong) LWHomeWalletModel *model;

@property (nonatomic, copy) EditViewBlock block;
@end

NS_ASSUME_NONNULL_END
