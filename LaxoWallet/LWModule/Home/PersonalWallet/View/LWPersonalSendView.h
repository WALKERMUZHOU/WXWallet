//
//  LWPersonalSendView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"
#import "LWHomeWalletModel.h"
#import "LWTransactionModel.h"

NS_ASSUME_NONNULL_BEGIN
//statue 0 失败 statue 1 成功
typedef void(^PersonalSendBlock)(NSInteger statue);

@interface LWPersonalSendView : LWBaseView

@property (nonatomic, copy) PersonalSendBlock block;

- (void)setWithLWTransactionModel:(LWTransactionModel *)transModel andModel:(LWHomeWalletModel *)model;

//- (void)setAddress:(NSString *)address andAmount:(NSString *)amount andMessage:(NSString *)note andModel:(LWHomeWalletModel *)model andChangeAddress:(NSString *)changeAddress;

@property (nonatomic, assign) BOOL ispayMail;

@end

NS_ASSUME_NONNULL_END
