//
//  LWWebSoketTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface LWWebSoketTool : NSObject
+ (LWWebSoketTool *)shareInstance;
- (void)webscoketSendData:(NSArray *)params andSuccessBlock:(void(^)(id result))block;

@end

NS_ASSUME_NONNULL_END
