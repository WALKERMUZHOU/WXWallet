//
//  LWSignessSatuteView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"
#import "LWHomeWalletModel.h"
#import "LWMessageModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^SignessSatuteViewBlock)(NSInteger sendStyle);

@interface LWSignessSatuteView : LWBaseView

- (void)setSignessSatuteViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel;

@property (nonatomic, copy) SignessSatuteViewBlock block;

@end

NS_ASSUME_NONNULL_END
