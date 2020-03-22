//
//  LWMultipySendToBeSignedView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWHomeWalletModel.h"
#import "LWMessageModel.h"


NS_ASSUME_NONNULL_BEGIN


typedef void(^SendToBeSignedBlock)(NSInteger signStyle);

@interface LWMultipySendToBeSignedView : UIView

- (void)setSignedViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel;

@property (nonatomic, copy) SendToBeSignedBlock block;

@end

NS_ASSUME_NONNULL_END
