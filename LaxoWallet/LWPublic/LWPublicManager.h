//
//  LWPublicManager.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, LWCurrentLanguage){
    LWCurrentLanguageChinese = 1,
    LWCurrentLanguageEnglish = 2,
};

typedef NS_OPTIONS(NSInteger, LWCurrentCurrency){
    LWCurrentCurrencyCNY = 1,
    LWCurrentCurrencyUSD = 2,
};

typedef NS_OPTIONS(NSInteger, TokenType){
    TokenTypeBSV = 1,
    TokenTypeBitCoin = 2,
};

@interface LWPublicManager : NSObject
+ (LWCurrentLanguage)getCurrentLanguage;
+ (LWCurrentCurrency)getCurrentCurrency;

+ (void)setCurrentLanguage:(LWCurrentLanguage)languageType;
+ (void)setCurrentCurrency:(LWCurrentCurrency)currencyType;
+ (NSString *)getCurrentCurrencyPrice;//得到当前币种汇率
///得到当前汇率带单位
+ (NSString *)getCurrentCurrencyPriceWithAmount:(CGFloat)amount;

+ (NSString *)getCurrentPriceWithTokenType:(TokenType)tokenType;

+ (NSString *)getPubkeyWithPriKey:(NSString *)prikey;
+ (NSString *)getPKWithZhuJiCi;
+ (NSString *)getPKWithZhuJiCiAndPath:(NSString *)path;

+ (NSString *)getRecoverJizhuciWithShares:(NSArray *)shares;
+ (NSString *)getSigWithMessage:(NSString *)timeStr;

+ (NSDictionary *)getInitData;
+ (NSString *)getInitDataPK;
+ (NSString *)getInitDataPubKey;

@end

NS_ASSUME_NONNULL_END
