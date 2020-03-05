//
//  LWAddressTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/2.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AddressBlock)(NSString *address);
@interface LWAddressTool : NSObject
+ (LWAddressTool *)shareInstance;
- (void)setWithrid:(NSString *)rid;
- (instancetype)initWithRid:(NSString *)rid;
@property (nonatomic, copy) AddressBlock addressBlock;


@end

NS_ASSUME_NONNULL_END
