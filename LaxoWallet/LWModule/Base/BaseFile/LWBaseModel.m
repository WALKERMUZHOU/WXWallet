//
//  LWBaseModel.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

@implementation LWBaseModel
/*
 //详细使用细心请跳转 https://github.com/ibireme/YYModel
 // JSON:
 {
 "n":"Harry Pottery",
 "p": 256,
 "ext" : {
 "desc" : "A book written by J.K.Rowing."
 },
 "ID" : 100010
 }
 
 // Model:
 @interface Book : NSObject
 @property NSString *name;
 @property NSInteger page;
 @property NSString *desc;
 @property NSString *bookID;
 @end
 @implementation Book
 + (NSDictionary *)modelCustomPropertyMapper {
 return @{@"name" : @"n",
 @"page" : @"p",
 @"desc" : @"ext.desc",
 @"bookID" : @[@"id",@"ID",@"book_id"]};
 }
 @end
 */

#pragma Coding/Copying/hash/equal/description

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (NSUInteger)hash { return [self modelHash]; }
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
- (NSString *)description { return [self modelDescription]; }

#if DEBUG

+ (NSDictionary*)modelCustomPropertyMapper {
    return [NSDictionary dictionary];
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return [NSDictionary dictionary];
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
//+ (NSArray*)modelPropertyWhitelist
//{
//    return [NSArray array];
//}

// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray*)modelPropertyBlacklist {
    return [NSArray array];
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    return YES;
}

#endif
@end
