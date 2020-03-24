//
//  LWSendViewAlertView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SendViewAlertBlock)(NSInteger signStyle);

@interface LWSendViewAlertView : UIView

- (void)setSignedViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel;

@property (nonatomic, copy) SendViewAlertBlock block;

@end

NS_ASSUME_NONNULL_END
