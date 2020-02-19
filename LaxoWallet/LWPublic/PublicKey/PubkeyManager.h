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

+ (NSString *)getencriptwithPrikey:(NSString *)prikey andPubkey:(NSString *)Pubkey adnMessage:(NSString *)message;

+ (void)getdecriptwithPrikey:(NSString *)prikey andPubkey:(NSString *)Pubkey adnMessage:(NSString *)message WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;


+ (void)getRecoverData:(NSArray *)shares WithSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

+ (void)getSigWithPK:(NSString *)pk message:(NSString *)message SuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

+ (void)getPrikeyByZhujiciSuccessBlock:(void(^)(id data))successBlock WithFailBlock:(void(^)(id data))FailBlock;

@end

NS_ASSUME_NONNULL_END
