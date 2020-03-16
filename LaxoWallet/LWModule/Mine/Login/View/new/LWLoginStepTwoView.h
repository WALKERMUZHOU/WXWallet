//
//  LWLoginStepTwoView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^StepTwoBlock)(NSString *email);
@interface LWLoginStepTwoView : UIView

@property (nonatomic, copy) StepTwoBlock block;

@end

NS_ASSUME_NONNULL_END
