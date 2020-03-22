//
//  LWMultipySendPendingView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"
#import "LWHomeWalletModel.h"
#import "LWMessageModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SendPendingBlock)(NSInteger sendStyle);

@interface LWMultipySendPendingView : LWBaseView

- (void)setSignedPendingViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel;

@property (nonatomic, copy) SendPendingBlock block;

@end

NS_ASSUME_NONNULL_END
