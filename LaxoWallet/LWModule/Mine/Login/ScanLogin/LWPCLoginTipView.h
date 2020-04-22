//
//  LWPCLoginTipView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/8.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PCLoginViewBlock)(void);
@interface LWPCLoginTipView : UIView
@property (nonatomic, copy) PCLoginViewBlock block;

- (void)refreshWithLanguageChange;

@end

NS_ASSUME_NONNULL_END
