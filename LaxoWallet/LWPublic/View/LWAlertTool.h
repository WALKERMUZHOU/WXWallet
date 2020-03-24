//
//  LWAlertTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWHomeWalletModel.h"

#import "LWHomeWalletModel.h"
#import "LWMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWAlertTool : NSObject

+ (void)alertHomeChooseWalletView:(void(^)(NSInteger index))walletBlock;

///个人钱包收款弹窗
+ (void)alertPersonalWalletViewReceive:(LWHomeWalletModel *)params ansComplete:(void(^)(NSInteger index))walletBlock;

///个人钱包发送弹窗
+ (void)alertPersonalWalletViewSend:(LWHomeWalletModel *)params andAdress:(NSString *)address andAmount:(NSString *)amount andNote:(NSString *)note andComplete:(void (^)(void))walletBlock;

+ (void)alertPersonalWalletViewSend:(LWHomeWalletModel *)params andAdress:(NSString *)address andAmount:(NSString *)amount andNote:(NSString *)note ispaymail:(BOOL)ispayMail andComplete:(void (^)(void))walletBlock;


+ (void)alertSendAlertView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id complete))walletBlock;

+ (void)alertReceiveddAlertView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id complete))walletBlock;

+ (void)alertMultipySignedView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id complete))walletBlock;

+ (void)alertMultipyOutgoingView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id complete))walletBlock;

+ (void)alertMultipyPendingView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id complete))walletBlock;

+ (void)alertMultipyCancleView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id complete))walletBlock;

+ (void)alertSigneseStatueView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id complete))walletBlock;


@end

NS_ASSUME_NONNULL_END
