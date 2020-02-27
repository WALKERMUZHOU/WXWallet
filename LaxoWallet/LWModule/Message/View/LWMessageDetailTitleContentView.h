//
//  LWMessageDetailTitleContentView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWMessageDetailTitleContentView : UIView

- (void)setTitle:(NSString *)title andContent:(id)content andIsShowTip:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
