//
//  LWPublicManager.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWHomeWalletModel.h"

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

+ (NSString *)getCurrentCurrencyEnglishCode;
+ (void)setCurrentCurrencyEnglishCode:(NSString *)currency;

+ (void)setCurrentLanguage:(LWCurrentLanguage)languageType;
+ (void)setCurrentCurrency:(LWCurrentCurrency)currencyType;
+ (NSString *)getCurrentCurrencyPrice;//得到当前币种汇率
+ (NSString *)getCurrentUSDPrice;//得到当前币种汇率

///得到当前汇率带单位
+ (NSString *)getCurrentCurrencyPriceWithAmount:(CGFloat)amount;
+ (NSString *)getCurrentPriceWithTokenType:(TokenType)tokenType;

#pragma mark - pk share...
+ (NSString *)getPubkeyWithPriKey:(NSString *)prikey;
+ (NSString *)getPKWithZhuJiCi;
+ (NSString *)getPubKeyWithZhuJiCi;

+ (NSString *)getPKWithZhuJiCiAndPath:(NSString *)path;

+ (NSString *)getRecoverJizhuciWithShares:(NSArray *)shares;
+ (NSString *)getSigWithMessage:(NSString *)timeStr;

+ (NSString *)getRecoverQRCodeStr;

+ (NSDictionary *)getInitData;
+ (NSString *)getInitDataPK;
+ (NSString *)getInitDataPubKey;

#pragma mark - walletData
+ (void)getPersonalWalletData;
+ (void)getMultipyWalletData;
+ (LWHomeWalletModel *)getPersonalFirstWallet;


@end

NS_ASSUME_NONNULL_END
