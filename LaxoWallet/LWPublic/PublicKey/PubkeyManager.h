//
//  PubkeyManager.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/12.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PubkeyManager : NSObject

+ (NSString *)getPubkey;
+ (NSString *)getPrikey;

//pass
+ (void)encriptwithPrikey:(NSString *)prikey andPubkey:(NSString *)Pubkey adnMessage:(NSString *)message WithSuccessBlock:(void(^)(id encriData))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//pass
+ (void)getdecriptwithPrikey:(NSString *)prikey andPubkey:(NSString *)Pubkey adnMessage:(NSString *)message WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//pass
+ (void)getRecoverData:(NSArray *)shares WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

+ (void)getSigWithPK:(NSString *)pk message:(NSString *)message SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//pass
+ (void)getPrikeyByZhujiciSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//pass
+ (void)getPrikeyByZhujiciandIndex:(NSInteger)index SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

+ (void)getPubKeyWithEmail:(NSString *)email SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//pass
+ (void)getDkWithSecret:(NSString *)secret andpJoin:(id)dq SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//pass
+ (void)decrptWithNoAppendNumberSecret:(NSString *)secret ansMessage:(NSString *)eqrCodeStr SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//pass
+ (void)encrptWithTheKey:(NSString *)secret andSecret_share:(NSString *)secret_share SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//pass
+ (void)decrptWithSecret:(NSString *)secret ansMessage:(NSString *)eqrCodeStr SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

//用于h得到个人收款二维码
+ (void)decrptWithSecret:(NSString *)secret andSecret_share:(NSString *)codeStr SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

@end

NS_ASSUME_NONNULL_END
