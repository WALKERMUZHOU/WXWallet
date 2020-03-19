//
//  LWAlertTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWAlertTool.h"
#import "LWHomeAddWalletView.h"
#import "LWPersoanlReceiveView.h"
#import "LWPersonalSendView.h"

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

+ (void)alertPersonalWalletViewReceive:(LWHomeWalletModel *)params ansComplete:(void (^)(NSInteger))walletBlock{
    UIView *backView = [LWAlertTool ligntBackView];
    
    LWPersoanlReceiveView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWPersoanlReceiveView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 560);
    [walletView setContentModel:params];
    
    [UIView animateWithDuration:0.3 animations:^{
        walletView.frame = CGRectMake(0, kScreenHeight - 560, kScreenWidth, 560);
    }];
    walletView.block = ^{
        [UIView animateWithDuration:0.3 animations:^{
              backView.alpha = 0;
          } completion:^(BOOL finished) {
              [backView removeFromSuperview];
          }];
    };
}

+ (void)alertPersonalWalletViewSend:(LWHomeWalletModel *)params andAdress:(NSString *)address andAmount:(NSString *)amount andNote:(NSString *)note andComplete:(void (^)(void))walletBlock{
    UIView *backView = [LWAlertTool ligntBackView];
    
    LWPersonalSendView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWPersonalSendView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 573);
//    [walletView setContentModel:params];
    [walletView setAddress:address andAmount:amount andMessage:note andModel:params];
    
    [UIView animateWithDuration:0.3 animations:^{
        walletView.frame = CGRectMake(0, kScreenHeight - 573, kScreenWidth, 573);
    }];
    walletView.block = ^(NSInteger statue) {
        [UIView animateWithDuration:0.3 animations:^{
             backView.alpha = 0;
         } completion:^(BOOL finished) {
             [backView removeFromSuperview];
         }];
        if (statue == 1) {
            walletBlock();
        }
    };
}

+ (UIView *)ligntBackView{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.tag = 100100;
    backView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.5];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    [window addSubview:backView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        NSLog(@"%@",sender);
//        UIGestureRecognizer *gesture = sender;
//        if (gesture.view.tag ==  10010) {
//            [UIView animateWithDuration:0.3 animations:^{
//                  backView.alpha = 0;
//            } completion:^(BOOL finished) {
//                  [backView removeFromSuperview];
//            }];
//        }
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
