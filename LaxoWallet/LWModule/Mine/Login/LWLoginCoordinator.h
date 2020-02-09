//
//  LWLoginCoordinator.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseCoordinator.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWLoginCoordinator : LWBaseCoordinator
+ (void)getSMSCodeWithEmail:(NSString *)email WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

+ (void)verifyEmailCodeWithEmail:(NSString *)email andCode:(NSString *)code WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;


@end

NS_ASSUME_NONNULL_END
