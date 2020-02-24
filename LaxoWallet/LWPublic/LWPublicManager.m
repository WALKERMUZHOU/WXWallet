//
//  LWPublicManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPublicManager.h"

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

@end
