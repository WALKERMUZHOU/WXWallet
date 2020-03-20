//
//  LWPublicManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPublicManager.h"
#import "CBSecp256k1.h"
#import "NSData+HexString.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"

@implementation LWPublicManager

+ (LWCurrentLanguage)getCurrentLanguage{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentLanguage_userdefault];
    if (language && [language isEqualToString:@"Chinese"]) {
        return LWCurrentLanguageEnglish;
    }
    return LWCurrentLanguageChinese;
}

+ (LWCurrentCurrency)getCurrentCurrency{
    NSString *currency = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentCurrency_userdefault];
    if (currency && [currency isEqualToString:@"cny"]) {
        return LWCurrentCurrencyCNY;
    }
    return LWCurrentCurrencyUSD;
}

+ (NSString *)getCurrentCurrencyPrice{
    return [LWPublicManager getCurrentPriceWithTokenType:TokenTypeBSV];
}

+ (NSString *)getCurrentCurrencyPriceWithAmount:(CGFloat)amount{
    NSString *currentcy = [LWPublicManager getCurrentPriceWithTokenType:TokenTypeBSV];
    
    CGFloat totalAmount = amount * currentcy.floatValue;
    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
        return [NSString stringWithFormat:@"¥ %.2f",totalAmount];
    }
    
    return [NSString stringWithFormat:@"$ %.2f",totalAmount];
}

+ (void)setCurrentLanguage:(LWCurrentLanguage)languageType{
    NSString *laguage ;
    if (languageType == LWCurrentLanguageChinese) {
        laguage = @"中文";
    }else{
        laguage = @"English";
    }
    [[NSUserDefaults standardUserDefaults] setObject:laguage forKey:kAppCurrentLanguage_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setCurrentCurrency:(LWCurrentCurrency)currencyType{
    NSString *laguage ;
    if (currencyType == LWCurrentCurrencyCNY) {
        laguage = @"cny";
    }else{
        laguage = @"usd";
    }
    [[NSUserDefaults standardUserDefaults] setObject:laguage forKey:kAppCurrentCurrency_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCurrentPriceWithTokenType:(TokenType)tokenType{
    NSString *tokenName;
    switch (tokenType) {
         case TokenTypeBSV:
            tokenName = @"bsv";
             break;
        case TokenTypeBitCoin:
            tokenName = @"bitCoin";
                break;
             
         default:
             break;
     }
    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAppTokenPrice_userdefault"];
    for (NSInteger i = 0; i<dataArray.count; i++) {
        NSDictionary *tokenDic = [dataArray objectAtIndex:i];
        if ([[tokenDic objectForKey:@"token"] isEqualToString:tokenName]) {
            if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
                return [tokenDic objectForKey:@"cny"];
            }else{
                return [tokenDic objectForKey:@"usd"];
            };
        }
    }
    return @"";
}

+ (NSString *)getPubkeyWithPriKey:(NSString *)prikey{
    NSData *prvData = [NSData hexStringToData:prikey];
    NSData *pubkey = [CBSecp256k1 generatePublicKeyWithPrivateKey:prvData compression:YES];
    return [pubkey hexString];
}

+ (NSString *)getPKWithZhuJiCi{
    LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
    NSString *seed = userModel.jiZhuCi;

    if (!seed || seed.length == 0) {//注册时未保存seed
       NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
        seed = [infoDic objectForKey:@"seed"];
        userModel.jiZhuCi = seed;
        [[LWUserManager shareInstance] setUser:userModel];
    }
    
    char *pk = derive_key([LWAddressTool stringToChar:seed], [LWAddressTool stringToChar:@"m/0"]);
    return [LWAddressTool charToString:pk];
}

+ (NSString *)getPubKeyWithZhuJiCi{
    LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
    NSString *seed = userModel.jiZhuCi;

    if (!seed || seed.length == 0) {//注册时未保存seed
       NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
        seed = [infoDic objectForKey:@"seed"];
        userModel.jiZhuCi = seed;
        [[LWUserManager shareInstance] setUser:userModel];
    }
    char *pk = derive_key([LWAddressTool stringToChar:seed], [LWAddressTool stringToChar:@"m/0"]);

    NSData *priData = [NSData hexStringToData:[NSString stringWithFormat:@"%s",pk]];
    NSData *pubkey = [CBSecp256k1 generatePublicKeyWithPrivateKey:priData compression:YES];
    return [pubkey hexString];
    
}

+ (NSString *)getPKWithZhuJiCiAndPath:(NSString *)path{
    NSString *seed = [[LWUserManager shareInstance] getUserModel].jiZhuCi;
    
    if (!seed || seed.length == 0) {//注册时未保存seed
       NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
        seed = [infoDic objectForKey:@"seed"];
    }
    
    char *pk = derive_key([LWAddressTool stringToChar:seed], [LWAddressTool stringToChar:path]);
    return [LWAddressTool charToString:pk];
}

+ (NSString *)getRecoverJizhuciWithShares:(NSArray *)shares{
    char *combine_shares_char = combine_shares([LWAddressTool objectToChar:shares]);
    return [LWAddressTool charToString:combine_shares_char];
}

+ (NSString *)getSigWithMessage:(NSString *)timeStr{
    NSString *prikey = [LWPublicManager getPKWithZhuJiCi];
    char *get_message_sig_char = get_message_sig([LWAddressTool stringToChar:timeStr], [LWAddressTool stringToChar:prikey]);
    return [LWAddressTool charToString:get_message_sig_char];
}

+ (NSDictionary *)getInitData{
    char *seed = get_seed();
    char *pk = derive_key(seed, [LWAddressTool stringToChar:@"m/0"]);
    char *secret = sha256(pk);
    char *shares = get_shares(seed, 2, 2);
    char *recover_seed = combine_shares(shares);
    char *publickey = get_public_key(pk);
    char *xpub = get_xpub(seed);
    NSString *shares_str = [LWAddressTool charToString:shares];
    NSArray *sharesArray = [NSJSONSerialization JSONObjectWithData:[shares_str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    
    NSDictionary *initDic = @{@"pk":[LWAddressTool charToString:pk],
    @"publicKey":[LWAddressTool charToString:publickey],
    @"secret":[LWAddressTool charToString:secret],
    @"seed":[LWAddressTool charToString:seed],
                              @"xpub":[LWAddressTool charToString:xpub],
    @"shares":sharesArray
    };
    [[NSUserDefaults standardUserDefaults] setObject:initDic forKey:kAppPubkeyManager_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return initDic;
}

+ (NSString *)getInitDataPK{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    return [infoDic objectForKey:@"pk"];
}

+ (NSString *)getInitDataPubKey{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    return [infoDic objectForKey:@"publicKey"];
}
@end
