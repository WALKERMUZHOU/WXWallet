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

@implementation LWPublicManager

+ (LWCurrentLanguage)getCurrentLanguage{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentLanguage_userdefault];
    if (language && [language isEqualToString:@"English"]) {
        return LWCurrentLanguageEnglish;
    }
    return LWCurrentLanguageChinese;
}

+ (LWCurrentCurrency)getCurrentCurrency{
    NSString *currency = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentCurrency_userdefault];
    if (currency && [currency isEqualToString:@"USD"]) {
        return LWCurrentCurrencyUSD;
    }
    return LWCurrentCurrencyCNY;
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
        laguage = @"CNY";
    }else{
        laguage = @"USD";
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
@end
