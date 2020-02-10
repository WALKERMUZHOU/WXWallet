//
//  LWTrusteeManager.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/9.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWTrusteeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWTrusteeManager : NSObject

+ (LWTrusteeManager *)shareInstance;
- (void)setTrustee:(NSArray *)trusteeArray;

- (LWTrusteeModel *)getFirstModel;
- (NSArray <LWTrusteeModel *> *)getTrusteeArray;


@end

NS_ASSUME_NONNULL_END
