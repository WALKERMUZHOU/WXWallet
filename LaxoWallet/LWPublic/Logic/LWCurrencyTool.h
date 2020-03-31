//
//  LWCurrencyTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/31.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWCurrencyTool : NSObject

///保存当前所有法币的汇率，基于usd
+ (void)setAllCurrency:(NSDictionary *)allCurrency;
///保存当前各种bit汇率，bsv，bitcoin。。。。（后期会有添加）
+ (void)setAllToken:(NSArray *)tokenArray;

///得到当前法币名称
+ (NSString *)getCurrentCurrencyEnglishCode;
///保存当前选中法币
+ (void)setCurrentCurrencyEnglishCode:(NSString *)currency;

///得到当前bit汇率 1bsv->170usd
+ (NSString *)getCurrentBitCurrency;
///根据当前bit数量 得到法币的值
+ (NSString *)getCurrentCurrencyWithBitCount:(CGFloat)bitCount;
///根据当前bit数量 得到法币的值（带单位）
+ (NSString *)getCurrentSymbolCurrencyWithBitCount:(CGFloat)bitCount;

+ (NSString *)getCurrentSymbolCurrencyWithBCurrency:(CGFloat)currency;


///根据当前法币数量 得到当前bitshul
+ (NSString *)getBitCountWithCurrency:(CGFloat)currency;


@end

NS_ASSUME_NONNULL_END
