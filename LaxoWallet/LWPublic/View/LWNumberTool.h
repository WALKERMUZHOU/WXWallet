//
//  LWNumberTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWNumberTool : NSObject

+ (NSString *)formatSSSFloat:(float)f;

+ (CGFloat)formatFloadString:(NSString *)fStr;

@end

NS_ASSUME_NONNULL_END
