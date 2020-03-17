//
//  LWLoginStepFiveView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^StepFiveBlock)(void);
@interface LWLoginStepFiveView : UIView

@property (nonatomic, copy) StepFiveBlock block;
@end

NS_ASSUME_NONNULL_END
