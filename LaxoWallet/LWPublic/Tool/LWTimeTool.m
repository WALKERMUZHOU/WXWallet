//
//  LWTimeTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWTimeTool.h"

@implementation LWTimeTool

+ (NSString *)dataFormateYYMMDD:(NSString *)timeStr{
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue/1000];
    NSString *time = [dateStringFormatter stringFromDate:date];
    return time;
}

+ (NSString *)dataFormateMMDDYYHHSS:(NSString *)timeStr{
    
    NSString *firstStr = [LWTimeTool EngLishMonthWithTimeStamp:timeStr abbreviations:YES EnglishShortNameForDate:NO];
    
    NSDateFormatter *dataHHSSFormatter = [[NSDateFormatter alloc] init];
    [dataHHSSFormatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue/1000];
    NSString *timeStrD = [dataHHSSFormatter stringFromDate:date];
    
    NSArray *timeArray = [timeStrD componentsSeparatedByString:@"-"];
    NSString *returnStr = [NSString stringWithFormat:@"%@ @ %@:%@",firstStr,timeArray[3],timeArray[4]];
    return returnStr;
    
}

/** 将一个时间为2015-05-20格式的字符串的月份转成英文月份
 *
 *  @param timeNormal  2015-05-20格式的字符串
 *
 *  @param abbreviations  是否使用月份缩写 是否使用日期缩写
 *
 *  @return 英文格式日期（可选） */
+ (NSString *)EngLishMonthWithTimeString:(NSString *)timeNormal abbreviations:(BOOL)abbreviations EnglishShortNameForDate:(BOOL)EnglishShortNameForDate {
    if (timeNormal.length != 10) {
        NSLog(@"时间格式错误");
        return nil;
    }
    return [self subStingOfYMD:timeNormal abbreviations:abbreviations EnglishShortNameForDate:EnglishShortNameForDate];
}

/** 将一个时间戳转换为2015-05-20格式的字符串，去掉0，再将其的月份转成英文月份
 *
 *  @param timeStamp  2015-05-20格式的字符串
 *
 *  @param abbreviations  是否使用月份缩写 是否使用日期缩写
 *
 *  @return 英文格式日期（可选） */
+ (NSString *)EngLishMonthWithTimeStamp:(NSString *)timeStamp abbreviations:(BOOL)abbreviations EnglishShortNameForDate:(BOOL)EnglishShortNameForDate
{
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"yyyy-MM-dd"];
    //SET_TIME_NORMAL_FORMATTER;//设置标准格式yyyy-mm-dd
    NSDate *changeDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/1000];
    NSString *time = [dateStringFormatter stringFromDate:changeDate];
    
    if (time.length != 10) {
        NSLog(@"时间格式错误");
        return nil;
    }
    
    return [self subStingOfYMD:time abbreviations:abbreviations EnglishShortNameForDate:EnglishShortNameForDate];
    
}

/** 将一个NSDate转换为2015-05-20格式的字符串，去掉0，再将其的月份转成英文月份
 *
 *  @param time  2015-05-20格式的字符串
 *
 *  @param abbreviations  是否使用月份缩写 是否使用日期缩写
 *
 *  @return 英文格式日期（可选） */
+ (NSString *)EngLishMonthWithDate:(NSDate *)date abbreviations:(BOOL)abbreviations EnglishShortNameForDate:(BOOL)EnglishShortNameForDate{
    
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeNormal = [dateStringFormatter stringFromDate:date];

    if (timeNormal.length != 10) {
        NSLog(@"时间格式错误");
        return nil;
    }
    return [self subStingOfYMD:timeNormal abbreviations:abbreviations EnglishShortNameForDate:EnglishShortNameForDate];
}

#pragma mark - Private
+ (NSString *)subStingOfYMD:(NSString *)time abbreviations:(BOOL)abbreviations EnglishShortNameForDate:(BOOL)EnglishShortNameForDate{
    
    //分别截取年月日
    //month
    NSRange range;
    range.length = 2;
    range.location = 5;
    NSString * a = [time substringWithRange:range];
    int aa = [a intValue];
    NSArray * array = nil;
    
    
    if (abbreviations) {//是否使用月份缩写
        array = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    } else {
        array = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    }
    NSString * timeStr = time;
    //day
    NSString * month = array[aa - 1];
    NSRange rangeDay;
    rangeDay.length = 2;
    rangeDay.location = 8;
    NSString * day = [time substringWithRange:rangeDay];
    
    //year
    NSRange rangeYear;
    rangeYear.length = 4;
    rangeYear.location = 0;
    NSString * year = [time substringWithRange:rangeYear];
    if (EnglishShortNameForDate) {//是否使用日期缩写
        if ([day intValue] > 9) {
            timeStr = [NSString stringWithFormat:@"%@ %@th", month, day];
        } else if ([day intValue] == 1) {
            day = [day stringByReplacingOccurrencesOfString:@"0" withString:@""];
            timeStr = [NSString stringWithFormat:@"%@ %@st", month, day];
        } else if ([day intValue] == 2) {
            day = [day stringByReplacingOccurrencesOfString:@"0" withString:@""];
            timeStr = [NSString stringWithFormat:@"%@ %@nd", month, day];
        } else if ([day intValue] == 3) {
            day = [day stringByReplacingOccurrencesOfString:@"0" withString:@""];
            timeStr = [NSString stringWithFormat:@"%@ %@rd", month, day];
        } else {
            day = [day stringByReplacingOccurrencesOfString:@"0" withString:@""];
            timeStr = [NSString stringWithFormat:@"%@ %@th", month, day];
        }
        time = [NSString stringWithFormat:@"%@,%@",timeStr,year];
    }else {
        time = [NSString stringWithFormat:@"%@ %@ %@",month,day,year];
    }
    
    return time;
    
}


@end
