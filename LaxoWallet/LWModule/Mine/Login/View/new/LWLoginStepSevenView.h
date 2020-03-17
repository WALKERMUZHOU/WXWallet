//
//  LWLoginStepSevenView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^StepSeven)(NSString *msgCode);
@interface LWLoginStepSevenView : UIView

@property (nonatomic, copy) StepSeven sevenBlock;

@end

NS_ASSUME_NONNULL_END
