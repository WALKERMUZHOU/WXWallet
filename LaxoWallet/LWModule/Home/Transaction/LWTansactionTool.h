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
typedef void(^TransactionFeeBlock)(NSString *fee);

@interface LWTansactionTool : NSObject

+ (LWTansactionTool *)shareInstance;

- (void)startTransactionWithAmount:(CGFloat)amount address:(NSString *)address note:(NSString *)note andTotalModel:(LWHomeWalletModel *)model andChangeAddress:(NSString *)changeAddress;
- (void)transStart;
@property (nonatomic, copy) TransactionBlock transactionBlock;
@property (nonatomic, copy) TransactionFeeBlock feeBlock;
@property (nonatomic, strong) NSString *fee;

@end

NS_ASSUME_NONNULL_END
