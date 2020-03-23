//
//  LWPersonalWalletEditViewController.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseViewController.h"
#import "LWHomeWalletModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^PersonalWalletEditBlock)(NSString *name);
@interface LWPersonalWalletEditViewController : LWBaseViewController

@property (nonatomic, strong) LWHomeWalletModel *model;
@property (nonatomic, copy) PersonalWalletEditBlock block;


@end

NS_ASSUME_NONNULL_END
