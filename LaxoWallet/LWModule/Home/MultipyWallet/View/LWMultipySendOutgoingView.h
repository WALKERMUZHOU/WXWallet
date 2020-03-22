//
//  LWMultipySendOutgoingView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"
#import "LWHomeWalletModel.h"
#import "LWMessageModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SendOutgoingBlock)(NSInteger sendStyle);

@interface LWMultipySendOutgoingView : LWBaseView

- (void)setSignedViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel;

@property (nonatomic, copy) SendOutgoingBlock block;

@end

NS_ASSUME_NONNULL_END
