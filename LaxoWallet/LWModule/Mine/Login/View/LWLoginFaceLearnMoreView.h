//
//  LWLoginFaceLearnMoreView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LearnMoreFaceBlock)(void);

@interface LWLoginFaceLearnMoreView : UIView
@property (nonatomic, copy) LearnMoreFaceBlock block;

@end

NS_ASSUME_NONNULL_END
