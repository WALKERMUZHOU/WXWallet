//
//  LWCurrentExchangeTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWCurrentExchangeTool : NSObject
+ (LWCurrentExchangeTool *)shareInstance;
- (void)getCurrentExchange;
@end

NS_ASSUME_NONNULL_END
