//
//  LWEncryptTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/11.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWEncryptTool.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+BFKit.h"
#import "NSData+HexString.h"
#import "NSString+BFKit.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"

NSString *iv = @"30303030303030303030303030303030";
@implementation LWEncryptTool
+ (NSString *)encrywithKey_tss:(NSString *)key message:(NSString *)message{

    // 1.16进制转成2进制
    NSData *encrypt_tss_key_data = [NSData hexStringToData:key];
    NSData *encrypt_tss_message_data = [NSData hexStringToData:message];
    NSData *ivData = [NSData hexStringToData:iv];
    
    NSData *testencrypt = [encrypt_tss_message_data aes256EncryptWithKey:encrypt_tss_key_data iv:ivData];
    NSString *testencrypt_hex = [testencrypt hexString];
    return testencrypt_hex;
}

+ (NSString *)decryptwithKey_tss:(NSString *)key message:(NSString *)message andHex:(NSInteger)ishex{
    // 1.16进制转成2进制
    NSData *key_data = [NSData hexStringToData:key];
    NSData *message_data = [NSData hexStringToData:message];
    NSData *ivData = [NSData hexStringToData:iv];
    
    NSData *decryptData = [message_data aes256DecryptWithkey:key_data iv:ivData];
    NSString *data_hex = [decryptData hexString];
//    NSString *data_str = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return data_hex;

}

+ (NSString *)decryptwithTheKey:(NSString *)key message:(NSString *)message andHex:(NSInteger)isHex{

    // 1.16进制转成2进制
        NSData *key_data = [NSData hexStringToData:key];
        NSData *message_data = [NSData hexStringToData:message];
        NSData *ivData = [NSData hexStringToData:iv];
        
        if (isHex == 0) {
            key_data = [key dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSData *decryptData = [message_data aes256DecryptWithkey:key_data iv:ivData];
        NSString *data_hex = [decryptData hexString];
        NSString *data_str = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return data_str;
}

+ (NSString *)encrywithTheKey:(NSString *)key message:(id)message andHex:(NSInteger)isHex{

    // 1.16进制转成2进制
    NSString *messageStr;
    if ([message isKindOfClass:[NSArray class]]) {
        messageStr = [message componentsJoinedByString:@","];
    }else{
        messageStr = (NSString *)message;
    }
    NSData *encrypt_tss_key_data = [NSData hexStringToData:key];
    NSData *encrypt_tss_message_data = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [NSData hexStringToData:iv];
    
    NSData *encryptdata = [encrypt_tss_message_data aes256EncryptWithKey:encrypt_tss_key_data iv:ivData];
    
    if (isHex == 0) {
        NSString *testencrypt_str = [[NSString alloc] initWithData:encryptdata encoding:NSUTF8StringEncoding];
        return testencrypt_str;
    }else{
        NSString *testencrypt_hex = [encryptdata hexString];
        return testencrypt_hex;
    }
}

+ (NSString *)encrywithTheKey:(NSString *)key message:(id)message andHex:(NSInteger)isHex returnType:(NSInteger)isEncryptWithHex{
    // 1.16进制转成2进制
    NSString *messageStr;
    if ([message isKindOfClass:[NSArray class]]) {
        messageStr = [message componentsJoinedByString:@","];
    }else{
        messageStr = (NSString *)message;
    }
    
    NSData *encrypt_tss_key_data = [NSData hexStringToData:key];
    if (!isHex) {
        encrypt_tss_key_data = [key dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSData *encrypt_tss_message_data = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [NSData hexStringToData:iv];
    
    NSData *encryptdata = [encrypt_tss_message_data aes256EncryptWithKey:encrypt_tss_key_data iv:ivData];
    
    if (isEncryptWithHex == 1) {
        NSString *testencrypt_hex = [encryptdata hexString];
          return testencrypt_hex;
    }else{
        NSString *testencrypt_str = [[NSString alloc] initWithData:encryptdata encoding:NSUTF8StringEncoding];
        return testencrypt_str;
    }
}

+ (NSString *)encryptWithPk:(NSString *)pk pubkey:(NSString *)pubkey andMessage:(NSString *)message{
    char *computeSecret = get_shared_secret([LWAddressTool stringToChar:pk], [LWAddressTool stringToChar:pubkey]);
    NSString *secret = [LWAddressTool charToString:computeSecret];
 
    // 1.16进制转成2进制
    NSData *key_data = [NSData dataWithHexString:secret];
    NSData *message_data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [NSData hexStringToData:iv];
    
    NSData *encryptdata = [message_data aes256EncryptWithKey:key_data iv:ivData];
    NSString *data_hex = [encryptdata hexString];
    return data_hex;
}

+ (NSString *)decryptWithPk:(NSString *)pk pubkey:(NSString *)pubkey andMessage:(NSString *)message{
    char *computeSecret = get_shared_secret([LWAddressTool stringToChar:pk], [LWAddressTool stringToChar:pubkey]);
    NSString *secret = [LWAddressTool charToString:computeSecret];
    
    NSData *key_data = [NSData dataWithHexString:secret];
    NSData *message_data = [NSData dataWithHexString:message];
    NSData *ivData = [NSData hexStringToData:iv];
    
    NSData *decryptData = [message_data aes256DecryptWithkey:key_data iv:ivData];
    NSString *data_hex = [decryptData hexString];
    NSString *data_str = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return data_str;
}

@end
