//
//  LWTansactionTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^TransactionBlock)(BOOL success);
@interface LWTansactionTool : NSObject

- (void)startTransactionWithAmount:(CGFloat)amount address:(NSString *)address note:(NSString *)note andTotalModel:(LWHomeWalletModel *)model;

@property (nonatomic, copy) TransactionBlock transactionBlock;

@end

NS_ASSUME_NONNULL_END
