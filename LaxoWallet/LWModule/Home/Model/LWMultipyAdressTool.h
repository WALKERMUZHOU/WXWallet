//
//  LWMultipySignTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/12.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWAddressTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMultipyAdressTool : NSObject
- (instancetype)initWithInitInfo:(NSArray *)info;
@property (nonatomic, copy) AddressBlock addressBlock;

@end

NS_ASSUME_NONNULL_END
