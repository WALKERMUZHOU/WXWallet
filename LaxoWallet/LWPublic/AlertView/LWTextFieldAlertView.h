//
//  LWTextFieldAlertView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWTextFieldAlertView : UIView

@property (nonatomic, copy) void(^lwAlertViewMakeSureBlock)(
NSString *repulse_evaluate_str/*打回内容*/
);//打回内容
@property (nonatomic, copy) void(^lwAlertViewCloseBlock)(void);//取消

- (instancetype)initWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeholder;
-(void)show;//弹出

@end

NS_ASSUME_NONNULL_END
