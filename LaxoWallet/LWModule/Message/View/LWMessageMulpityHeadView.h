//
//  LWMessageMulpityHeadView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWHomeWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMessageMulpityHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame andModel:(LWHomeWalletModel *)partiesModel;

- (void)showWithViewController:(UIViewController *)viewController;
- (void)dismiss;
@property (nonatomic, assign) CGFloat viewHeight;

@end

NS_ASSUME_NONNULL_END
