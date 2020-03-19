//
//  LWAlertTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWAlertTool : NSObject

+ (void)alertHomeChooseWalletView:(void(^)(NSInteger index))walletBlock;


@end

NS_ASSUME_NONNULL_END
