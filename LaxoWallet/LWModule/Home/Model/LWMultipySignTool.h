//
//  LWMultipySignTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWSignTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMultipySignTool : NSObject

+ (LWMultipySignTool *)shareInstance;
- (void)setWithAddress:(NSString *)address andHash:(NSString *)hash;

- (instancetype)initWithInitInfo:(NSArray *)info;


@property (nonatomic, copy) SignBlock signBlock;

@end

NS_ASSUME_NONNULL_END
