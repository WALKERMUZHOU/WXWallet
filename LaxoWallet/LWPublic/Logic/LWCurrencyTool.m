//
//  LWCurrencyTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/31.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWCurrencyTool.h"

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
            
            CGFloat currentBitCurrency = usdTokenPrice * currencyToUsd;
            return [LWNumberTool formatSSSFloat:currentBitCurrency];
        }
    }
    return @"";
}

+ (NSString *)getCurrentCurrencyWithBitCount:(CGFloat)bitCount{
    NSString *currentCurrency = [LWCurrencyTool getCurrentBitCurrency];
    CGFloat currencyWithBitCount = currentCurrency.floatValue * bitCount;
    return [LWNumberTool formatSSSFloat:currencyWithBitCount];
}

+ (NSString *)getCurrentSymbolCurrencyWithBitCount:(CGFloat)bitCount{
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

+ (NSString *)getCurrentSymbolCurrencyWithBCurrency:(CGFloat)currency{
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

+ (NSString *)getBitCountWithCurrency:(CGFloat)currency{
    return [LWNumberTool formatSSSFloat:currency/[LWCurrencyTool getCurrentBitCurrency].floatValue];
}
@end
