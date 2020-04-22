//
//  LWCurrencyTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/31.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWCurrencyTool.h"
#import "NSBundle+AppLanguageSwitch.h"

@implementation LWCurrencyTool

+ (void)setAllCurrency:(NSDictionary *)allCurrency{
    NSString *allCurrencyJson = [allCurrency jsonStringEncoded];
    NSString *upperJson = [allCurrencyJson uppercaseString];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[upperJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kAppCurrencyToUSD_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getAllCurrency{
    NSDictionary *allCurrency = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrencyToUSD_userdefault];
    return allCurrency;
}

+ (void)setAllToken:(NSArray *)tokenArray{
    [[NSUserDefaults standardUserDefaults] setObject:tokenArray forKey:kAppTokenPrice_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getAllTokenArray{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kAppTokenPrice_userdefault];
    return array;
}

+ (NSString *)getCurrentCurrencyEnglishCode{
    NSString *currency = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentCurrencyName_userdefault];
    if (currency && currency.length>0) {
        return currency;
    }
    
    NSString *language = [NSBundle getCusLanguage];
    if ([language isEqualToString:@"zh-Hans"]) {
        [LWCurrencyTool setCurrentCurrencyEnglishCode:@"CNY"];
        return @"CNY";
    }
    [LWCurrencyTool setCurrentCurrencyEnglishCode:@"USD"];
    return @"USD";
}

+ (void)setCurrentCurrencyEnglishCode:(NSString *)currency{
    [[NSUserDefaults standardUserDefaults] setObject:currency forKey:kAppCurrentCurrencyName_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCurrentBitCurrency{
    NSString *tokenName = @"bsv";
    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAppTokenPrice_userdefault];
    for (NSInteger i = 0; i<dataArray.count; i++) {
        NSDictionary *tokenDic = [dataArray objectAtIndex:i];
        if ([[tokenDic objectForKey:@"token"] isEqualToString:tokenName]) {
            CGFloat usdTokenPrice = [[tokenDic objectForKey:@"usd"] floatValue];
            NSDictionary *allCurrencyDic = [LWCurrencyTool getAllCurrency];
            CGFloat currencyToUsd = [[allCurrencyDic objectForKey:[LWPublicManager getCurrentCurrencyEnglishCode] ] floatValue];
            
            double currentBitCurrency = usdTokenPrice * currencyToUsd;
            return [LWNumberTool formatSSSFloat:currentBitCurrency];
        }
    }
    return @"";
}

+ (NSString *)getCurrentCurrencyWithBitCount:(double)bitCount{
    NSString *currentCurrency = [LWCurrencyTool getCurrentBitCurrency];
    double currencyWithBitCount = currentCurrency.floatValue * bitCount;
    
    return [NSString stringWithFormat:@"%.2f",currencyWithBitCount];
}

+ (NSString *)getCurrentSymbolCurrencyWithBitCount:(double)bitCount{
    NSString *currentCurrencyType = [LWCurrencyTool getCurrentCurrencyEnglishCode];
    
    NSString *typeArrayPath = [[NSBundle mainBundle] pathForResource:@"currency" ofType:@"plist"];
    NSArray *typeArray = [[NSArray array] initWithContentsOfFile:typeArrayPath];
    
    NSString *currentCurrency = [LWCurrencyTool getCurrentCurrencyWithBitCount:bitCount];
    
    for (NSInteger i = 0; i<typeArray.count; i++) {
        NSDictionary *currencyDic = [typeArray objectAtIndex:i];
        NSString *currencyCode = [currencyDic objectForKey:@"currencyCode"];
        if ([currencyCode isEqualToString:currentCurrencyType]) {
            NSString *symbolStr = [currencyDic objectForKey:@"currencytSymbol"];
            return [NSString stringWithFormat:@"%@%.2f %@",symbolStr,currentCurrency.floatValue,currentCurrencyType];
        }
    }
    return [NSString stringWithFormat:@"%.2f%@",currentCurrency.floatValue,currentCurrencyType];
}

+ (NSString *)getCurrentSymbolCurrencyWithBCurrency:(double)currency{
    NSString *currentCurrencyType = [LWCurrencyTool getCurrentCurrencyEnglishCode];
    
    NSString *typeArrayPath = [[NSBundle mainBundle] pathForResource:@"currency" ofType:@"plist"];
    NSArray *typeArray = [[NSArray array] initWithContentsOfFile:typeArrayPath];
    
    NSString *currentCurrency = [LWNumberTool formatSSSFloat:currency];
    
    for (NSInteger i = 0; i<typeArray.count; i++) {
        NSDictionary *currencyDic = [typeArray objectAtIndex:i];
        NSString *currencyCode = [currencyDic objectForKey:@"currencyCode"];
        if ([currencyCode isEqualToString:currentCurrencyType]) {
            NSString *symbolStr = [currencyDic objectForKey:@"currencytSymbol"];
            return [NSString stringWithFormat:@"%@%.2f %@",symbolStr,currentCurrency.floatValue,currentCurrencyType];
        }
    }
    return [NSString stringWithFormat:@"%.2f%@",currentCurrency.floatValue,currentCurrencyType];
}

+ (NSString *)getBitCountWithCurrency:(double)currency{
    return [LWNumberTool formatSSSFloat:currency/[LWCurrencyTool getCurrentBitCurrency].floatValue];
}

+ (NSString *)getCurrentCurrencyAmountWithUSDAmount:(double)usd{
    NSDictionary *allCurrencyDic = [LWCurrencyTool getAllCurrency];
    double currencyToUsd = [[allCurrencyDic objectForKey:[LWPublicManager getCurrentCurrencyEnglishCode] ] doubleValue];
    return  [LWNumberTool formatSSSFloat:usd/currencyToUsd];
}

+ (NSString *)getCurrentSymbolCurrencyAmountWithUSDAmount:(double)usd{
    NSString *currentCurrencyType = [LWCurrencyTool getCurrentCurrencyEnglishCode];
    NSString *typeArrayPath = [[NSBundle mainBundle] pathForResource:@"currency" ofType:@"plist"];
    NSArray *typeArray = [[NSArray array] initWithContentsOfFile:typeArrayPath];
              
    double currencyToUSD = [LWCurrencyTool getCurrentCurrencyAmountWithUSDAmount:usd].doubleValue;
    for (NSInteger i = 0; i<typeArray.count; i++) {
       NSDictionary *currencyDic = [typeArray objectAtIndex:i];
       NSString *currencyCode = [currencyDic objectForKey:@"currencyCode"];
       if ([currencyCode isEqualToString:currentCurrencyType]) {
           NSString *symbolStr = [currencyDic objectForKey:@"currencytSymbol"];
           return [NSString stringWithFormat:@"%@%.2f %@",symbolStr,currencyToUSD,currentCurrencyType];
       }
    }
    return [NSString stringWithFormat:@"%.2f%@",currencyToUSD,currentCurrencyType];
}
@end
