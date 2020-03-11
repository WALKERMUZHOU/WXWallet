//
//  LWEncryptTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/11.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWEncryptTool : NSObject

+ (NSString *)encrywithKey_tss:(NSString *)key message:(NSString *)message;
+ (NSString *)decryptwithKey_tss:(NSString *)key message:(NSString *)message andHex:(NSInteger)isHex;

+ (NSString *)encrywithTheKey:(NSString *)key message:(id)message andHex:(NSInteger)isHex;;
+ (NSString *)decryptwithTheKey:(NSString *)key message:(NSString *)message andHex:(NSInteger)isHex;

+ (NSString *)encryptWithPk:(NSString *)pk pubkey:(NSString *)pubkey andMessage:(NSString *)message;
+ (NSString *)decryptWithPk:(NSString *)pk pubkey:(NSString *)pubkey andMessage:(NSString *)message;



@end

NS_ASSUME_NONNULL_END
