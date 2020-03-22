//
//  LWTimeTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWTimeTool : NSObject

+ (NSString *)dataFormateYYMMDD:(NSString *)timeStr;

+ (NSString *)dataFormateMMDDYYHHSS:(NSString *)timeStr;



+ (NSString *)EngLishMonthWithTimeString:(NSString *)timeNormal abbreviations:(BOOL)abbreviations EnglishShortNameForDate:(BOOL)EnglishShortNameForDate;
+ (NSString *)EngLishMonthWithTimeStamp:(NSString *)timeStamp abbreviations:(BOOL)abbreviations EnglishShortNameForDate:(BOOL)EnglishShortNameForDate;
+ (NSString *)EngLishMonthWithDate:(NSDate *)date abbreviations:(BOOL)abbreviations EnglishShortNameForDate:(BOOL)EnglishShortNameForDate;
+ (NSString *)subStingOfYMD:(NSString *)time abbreviations:(BOOL)abbreviations EnglishShortNameForDate:(BOOL)EnglishShortNameForDate;
@end

NS_ASSUME_NONNULL_END
