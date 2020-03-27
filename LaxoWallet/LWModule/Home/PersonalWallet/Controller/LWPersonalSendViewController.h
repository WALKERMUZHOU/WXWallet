//
//  LWPersonalSendViewController.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseViewController.h"
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface LWPersonalSendViewController : LWBaseViewController

@property (nonatomic, strong) LWHomeWalletModel *model;
///viewtype = 1 多人钱包
@property (nonatomic, assign) NSInteger viewType;

@property (nonatomic, strong) NSString *sendAddress;

@end

NS_ASSUME_NONNULL_END
