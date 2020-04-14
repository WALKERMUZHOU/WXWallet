//
//  LWNumberInputView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NumberInputBlock)(NSString *inputNum);
@interface LWNumberInputView : UIView

@property (nonatomic, copy) NumberInputBlock block;

@end

NS_ASSUME_NONNULL_END
