//
//  LWNumberTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWNumberTool.h"

@implementation LWNumberTool

+ (NSString *)formatSSSFloat:(double)f{
    if (fmod(f, 1)==0) { //无有效小数位
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmod(f*10, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    }else if (fmod(f*100, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.2f",f];
    } else if (fmod(f*1000, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.3f",f];
    } else if (fmod(f*10000, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.4f",f];
    } else if (fmod(f*100000, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.5f",f];
    } else if (fmod(f*1000000, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.6f",f];
    } else if (fmod(f*10000000, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.7f",f];
    } else if (fmod(f*100000000, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.8f",f];
    } else {//如果有两位或以上小数点
        return [NSString stringWithFormat:@"%.8f",f];
    }
}

+ (CGFloat)formatFloadString:(NSString *)fStr{
    NSArray *array = [fStr componentsSeparatedByString:@"."];
    if (array.count == 2) {
        NSDecimalNumber *textNum = [NSDecimalNumber decimalNumberWithString:fStr];
        return textNum.doubleValue;
    }
    return fStr.floatValue;
}

@end
