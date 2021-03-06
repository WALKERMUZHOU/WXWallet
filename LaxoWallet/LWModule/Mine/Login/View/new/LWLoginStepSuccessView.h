//
//  LWLoginStepSuccessView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^StepSuccessBlock)(void);
@interface LWLoginStepSuccessView : UIView

@property (nonatomic, copy) StepSuccessBlock successBlock;

@end

NS_ASSUME_NONNULL_END
