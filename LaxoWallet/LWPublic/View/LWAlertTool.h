//
//  LWAlertTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWAlertTool : NSObject

+ (void)alertHomeChooseWalletView:(void(^)(NSInteger index))walletBlock;

///个人钱包收款弹窗
+ (void)alertPersonalWalletViewReceive:(LWHomeWalletModel *)params ansComplete:(void(^)(NSInteger index))walletBlock;

///个人钱包发送弹窗
+ (void)alertPersonalWalletViewSend:(LWHomeWalletModel *)params andAdress:(NSString *)address andAmount:(NSString *)amount andNote:(NSString *)note andComplete:(void (^)(void))walletBlock;

@end

NS_ASSUME_NONNULL_END
