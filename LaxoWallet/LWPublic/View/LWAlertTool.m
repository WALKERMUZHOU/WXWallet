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

#import "LWSendViewAlertView.h"
#import "LWReceivedViewAlertView.h"
#import "LWMultipySendToBeSignedView.h"
#import "LWMultipySendOutgoingView.h"
#import "LWMultipySendPendingView.h"
#import "LWMultipySendCancleView.h"

#import "LWSignessSatuteView.h"

#import "LWLoginLearnMoreView.h"
#import "LWLoginFaceLearnMoreView.h"

@implementation LWAlertTool

+ (void)alertHomeChooseWalletView:(void (^)(NSInteger))walletBlock{
    UIView *backView = [LWAlertTool ligntBackView];
    
    LWHomeAddWalletView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWHomeAddWalletView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 159);
   
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            NSLog(@"%@",sender);
        }];
    [walletView addGestureRecognizer:tap1];
    
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
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            NSLog(@"%@",sender);
        }];
    [walletView addGestureRecognizer:tap1];
    
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

+ (void)alertSendAlertView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id _Nonnull))walletBlock{
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWSendViewAlertView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWSendViewAlertView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, viewHeight);
    [walletView setSignedViewWithWalletModel:walletModel andMessageModel:messageModel];
    walletView.block = ^(NSInteger signStyle) {
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
        if (signStyle == 1) {
            
            
        }
    };
    
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];
}

+ (void)alertReceiveddAlertView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id _Nonnull))walletBlock{
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWReceivedViewAlertView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWReceivedViewAlertView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, viewHeight);
    [walletView setSignedViewWithWalletModel:walletModel andMessageModel:messageModel];
    walletView.block = ^(NSInteger signStyle) {
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
        if (signStyle == 1) {
            
            
        }
    };
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];
}

+ (void)alertPersonalWalletViewSend:(LWHomeWalletModel *)params andTransactionModel:(LWTransactionModel *)transModel andComplete:(void (^)(void))walletBlock{
        UIView *backView = [LWAlertTool ligntBackView];
        
       
    LWPersonalSendView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWPersonalSendView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 568);
    //    [walletView setContentModel:params];
    [walletView setWithLWTransactionModel:transModel andModel:params];
        
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            NSLog(@"%@",sender);
        }];
    [walletView addGestureRecognizer:tap1];
    
    [UIView animateWithDuration:0.3 animations:^{
        walletView.frame = CGRectMake(0, kScreenHeight - 568, kScreenWidth, 568);
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

//+ (void)alertPersonalWalletViewSend:(LWHomeWalletModel *)params andAdress:(NSString *)address andAmount:(NSString *)amount andNote:(NSString *)note changeAddress:(NSString *)changeAddress andComplete:(void (^)(void))walletBlock{
//    UIView *backView = [LWAlertTool ligntBackView];
//    
//    LWPersonalSendView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWPersonalSendView class]) owner:nil options:nil].lastObject;
//    [backView addSubview:walletView];
//    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 573);
////    [walletView setContentModel:params];
//    
//    [walletView setAddress:address andAmount:amount andMessage:note andModel:params andChangeAddress:changeAddress];
//    
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//            NSLog(@"%@",sender);
//        }];
//    [walletView addGestureRecognizer:tap1];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        walletView.frame = CGRectMake(0, kScreenHeight - 573, kScreenWidth, 573);
//    }];
//    walletView.block = ^(NSInteger statue) {
//        [UIView animateWithDuration:0.3 animations:^{
//             backView.alpha = 0;
//         } completion:^(BOOL finished) {
//             [backView removeFromSuperview];
//         }];
//        if (statue == 1) {
//            walletBlock();
//        }
//    };
//}

//+ (void)alertPersonalWalletViewSend:(LWHomeWalletModel *)params andAdress:(NSString *)address andAmount:(NSString *)amount andNote:(NSString *)note changeAddress:(NSString *)changeAddress ispaymail:(BOOL)ispayMail andComplete:(void (^)(void))walletBlock{
//        UIView *backView = [LWAlertTool ligntBackView];
//        
//        LWPersonalSendView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWPersonalSendView class]) owner:nil options:nil].lastObject;
//        [backView addSubview:walletView];
//        walletView.ispayMail = YES;
//        walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 573);
//    //    [walletView setContentModel:params];
//        
//        [walletView setAddress:address andAmount:amount andMessage:note andModel:params andChangeAddress:changeAddress];
//        
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//            NSLog(@"%@",sender);
//        }];
//    [walletView addGestureRecognizer:tap1];
//    
//        [UIView animateWithDuration:0.3 animations:^{
//            walletView.frame = CGRectMake(0, kScreenHeight - 573, kScreenWidth, 573);
//        }];
//        walletView.block = ^(NSInteger statue) {
//            [UIView animateWithDuration:0.3 animations:^{
//                 backView.alpha = 0;
//             } completion:^(BOOL finished) {
//                 [backView removeFromSuperview];
//             }];
//            if (statue == 1) {
//                walletBlock();
//            }
//        };
//}

+ (void)alertMultipySignedView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id _Nonnull))walletBlock{
    
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWMultipySendToBeSignedView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWMultipySendToBeSignedView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, viewHeight);
    [walletView setSignedViewWithWalletModel:walletModel andMessageModel:messageModel];
    walletView.block = ^(NSInteger signStyle) {
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
        if (signStyle == 1) {
            
            
        }
    };
    
    
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];
     
//     walletView.block = ^(NSInteger selectIndex) {
//         walletBlock(selectIndex);
//         [UIView animateWithDuration:0.3 animations:^{
//             backView.alpha = 0;
//         } completion:^(BOOL finished) {
//             [backView removeFromSuperview];
//         }];
//     };
    
}

+ (void)alertMultipyOutgoingView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id _Nonnull))walletBlock{
    
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWMultipySendOutgoingView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWMultipySendOutgoingView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, viewHeight);
    [walletView setSignedViewWithWalletModel:walletModel andMessageModel:messageModel];
    walletView.block = ^(NSInteger signStyle) {
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
        if (signStyle == 1) {
            
            
        }
    };
    
    
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];
    
    
}

+ (void)alertMultipyPendingView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id _Nonnull))walletBlock{
    
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWMultipySendPendingView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWMultipySendPendingView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, viewHeight);
    [walletView setSignedPendingViewWithWalletModel:walletModel andMessageModel:messageModel];
    walletView.block = ^(NSInteger signStyle) {
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
        if (signStyle == 1) {
            
            
        }
    };
    
    
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];
    
    
}

+ (void)alertMultipyCancleView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id _Nonnull))walletBlock{
    
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWMultipySendCancleView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWMultipySendCancleView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, viewHeight);
    [walletView setSignedCancelViewWithWalletModel:walletModel andMessageModel:messageModel];
    walletView.block = ^(NSInteger signStyle) {
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
        if (signStyle == 1) {
            
            
        }
    };
    
    
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];
    
}

+ (void)alertSigneseStatueView:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel andComplete:(void (^)(id _Nonnull))walletBlock{
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWSignessSatuteView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWSignessSatuteView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight);
    [walletView setSignessSatuteViewWithWalletModel:walletModel andMessageModel:messageModel];
    walletView.block = ^(NSInteger signStyle) {
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
        if (signStyle == 1) {
            
            
        }
    };
    
    
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];
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

+ (void)alertloginLaeanMore{
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWLoginLearnMoreView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginLearnMoreView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight);
    walletView.block = ^{
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    };
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];

}

+ (void)alertloginLaeanMoreFace{
    CGFloat viewHeight =  568.f;
    UIView *backView = [LWAlertTool ligntBackView];
     
    LWLoginFaceLearnMoreView *walletView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginFaceLearnMoreView class]) owner:nil options:nil].lastObject;
    [backView addSubview:walletView];
    walletView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight);
    walletView.block = ^{
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    };
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
             NSLog(@"%@",sender);
         }];
     [walletView addGestureRecognizer:tap1];
     
     [UIView animateWithDuration:0.3 animations:^{
         walletView.frame = CGRectMake(0, kScreenHeight - viewHeight, kScreenWidth, viewHeight);
     }];
}

@end
