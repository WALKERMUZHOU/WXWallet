//
//  LWSignTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/6.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SignBlock)(NSDictionary *sign);
@interface LWSignTool : NSObject

+ (LWSignTool *)shareInstance;

- (void)setWithResponseInfo:(NSDictionary *)respone;


- (void)setWithAddress:(NSString *)address andHash:(NSString *)hash;
- (void)setWithAddress:(NSString *)address;
- (instancetype)initWithAddress:(NSString *)address;

@property (nonatomic, copy) SignBlock signBlock;

@end

NS_ASSUME_NONNULL_END
