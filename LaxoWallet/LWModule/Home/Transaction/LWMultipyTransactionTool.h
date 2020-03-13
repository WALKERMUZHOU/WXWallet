//
//  LWMultipyTransactionTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWTansactionTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMultipyTransactionTool : NSObject

+ (LWMultipyTransactionTool *)shareInstance;

- (void)startTransactionWithAmount:(CGFloat)amount address:(NSString *)address note:(NSString *)note andTotalModel:(LWHomeWalletModel *)model;

@end

NS_ASSUME_NONNULL_END
