//
//  LWPersoanlReceiveView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PersoanlReceiveBlock)(void);

@interface LWPersoanlReceiveView : LWBaseView

@property (nonatomic, copy) PersoanlReceiveBlock block;
- (void)setContentModel:(LWHomeWalletModel *)model;
@end

NS_ASSUME_NONNULL_END
