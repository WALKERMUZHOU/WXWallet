//
//  LWLoginStepOneView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^StepOneBlock)(void);
@interface LWLoginStepOneView : UIView

@property (nonatomic, copy) StepOneBlock block;
@end

NS_ASSUME_NONNULL_END