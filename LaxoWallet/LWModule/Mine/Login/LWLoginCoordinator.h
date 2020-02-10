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
//登录获取验证码
+ (void)getSMSCodeWithEmail:(NSString *)email WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;
//验证登录验证码
+ (void)verifyEmailCodeWithEmail:(NSString *)email andCode:(NSString *)code WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//获取恢复验证码
+ (void)getRecoverySMSCodeWithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;
//d验证恢复验证码
+ (void)verifyRecoveryEmailCodeWithEmail:(NSString *)email andCode:(NSString *)code WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

+ (void)getTrueteeDataWithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;


@end

NS_ASSUME_NONNULL_END
