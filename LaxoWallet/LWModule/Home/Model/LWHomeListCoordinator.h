//
//  LWHomeListCoordinator.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseCoordinator.h"

NS_ASSUME_NONNULL_BEGIN


@interface LWHomeListCoordinator : LWBaseCoordinator

+ (void)getTokenPriceWithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

+ (void)getCurrentCurrencyWithUSDWithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;;

+ (void)getCollectionCodeWithWalletId:(NSInteger)walletID withSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;
@end

NS_ASSUME_NONNULL_END
