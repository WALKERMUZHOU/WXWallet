//
//  UIView+LWPayView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^LWPayBlock)(BOOL isSend);

@interface UIView (LWPayView)

/** 只弹出文字列表
 *  array ：弹出的选项标题
 *  textColor ：选项标题的字体颜色 可设置两种类型，数组颜色或者单个颜色（NSArray/UIColor）
 *  font ：选项标题的字体
 *  取消 按钮字体请到.m文件自行设置。默认黑色-16号
 **/
-(void)createAlertViewWithTitle:(NSString* )title amount:(NSString *)amount payMail:(NSString *)payMail address:(NSString *)address actionBlock:(LWPayBlock _Nullable )actionBlock;

@end

NS_ASSUME_NONNULL_END
