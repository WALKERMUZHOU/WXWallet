//
//  LWPersonalSendView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PersonalSendBlock)(NSInteger statue);

@interface LWPersonalSendView : LWBaseView

@property (nonatomic, copy) PersonalSendBlock block;

- (void)setAddress:(NSString *)address andAmount:(NSString *)amount andMessage:(NSString *)note andModel:(LWHomeWalletModel *)model;

@end

NS_ASSUME_NONNULL_END
