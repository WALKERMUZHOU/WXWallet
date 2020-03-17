//
//  LWLoginStepEightView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^StepEightBlock)(NSInteger index);
@interface LWLoginStepEightView : UIView
@property (nonatomic, copy) StepEightBlock block;
@end

NS_ASSUME_NONNULL_END
