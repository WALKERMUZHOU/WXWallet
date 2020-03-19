//
//  LWHomeAddWalletView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HomeAddWalletBlock)(NSInteger selectIndex);
@interface LWHomeAddWalletView : UIView

@property (nonatomic, copy) HomeAddWalletBlock block;

@end

NS_ASSUME_NONNULL_END
