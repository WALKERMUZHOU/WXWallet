//
//  LWSendAmountChangeView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/14.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SendAmountBlock)(NSString *bitCount,NSString *currencyAmount);
@interface LWNumberOutputView : UIView

- (void)setTopAmount:(NSString *)amount;

- (void)setBitAmount:(NSString *)amount;
@property (nonatomic, copy) SendAmountBlock block;

@end

NS_ASSUME_NONNULL_END
