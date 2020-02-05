//
//  LWBaseModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWBaseModel : NSObject
#if DEBUG
/**
 *  YYModel适配属性键值 key:属性名     value:字典的key
 *
 *  @return 字典
 */

+ (NSDictionary *)modelCustomPropertyMapper;

/**
 * YYModel 适配嵌套模型  key:属性名   value:嵌套模型的class
 *
 *  @return 字典
 */

+ (NSDictionary *)modelContainerPropertyGenericClass;

/**
 *  YYModel黑名单
 *
 *  @return 数组
 */
+ (NSArray *)modelPropertyBlacklist;

/**
 *  YYModel白名单
 *
 *  @return 白名单
 */
//+ (NSArray *)modelPropertyWhitelist;

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic ;

#endif
@end

NS_ASSUME_NONNULL_END
