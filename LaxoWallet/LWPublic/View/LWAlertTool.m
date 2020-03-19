//
//  LWAlertTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWAlertTool.h"
#import "LWHomeAddWalletView.h"

@implementation LWAlertTool

+ (void)alertHomeChooseWalletView:(void (^)(NSInteger))walletBlock{
    UIView *backView = [LWAlertTool ligntBackView];
    
    LWHomeAddWalletView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWHomeAddWalletView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 159);
    
    [UIView animateWithDuration:0.3 animations:^{
        walletView.frame = CGRectMake(0, kScreenHeight - 159, kScreenWidth, 159);
    }];
    
    walletView.block = ^(NSInteger selectIndex) {
        walletBlock(selectIndex);
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    };
}

+ (UIView *)ligntBackView{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.5];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    [window addSubview:backView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {

        [UIView animateWithDuration:0.3 animations:^{
             backView.alpha = 0;
         } completion:^(BOOL finished) {
             [backView removeFromSuperview];
         }];

    }];

    [backView addGestureRecognizer:tap1];
    return backView;
}

@end
