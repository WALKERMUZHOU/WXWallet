//
//  UIView+LWPayView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "UIView+LWPayView.h"

#import "LWCommonBottomBtn.h"
#import "POP.h"
#import "TDTouchID.h"
#import "WMZDialogTool.h"

@implementation UIView (LWPayView)

UIView *backgroundV;
UIView *bottomView;
float height;

static NSString *keyOfMethod; //关联者的索引key-用于获取block

- (void)createAlertViewWithTitle:(NSString *)title amount:(NSString *)amount payMail:(NSString *)payMail address:(NSString *)address actionBlock:(LWPayBlock)actionBlock{
    
    CGFloat preLeft = 12.f;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appdelegate.window;

    backgroundV = [[UIView alloc]initWithFrame:window.bounds];
    backgroundV.backgroundColor = RGBA(0, 0, 0, 0);
    [window addSubview:backgroundV];
    
    //点击手势
    UITapGestureRecognizer *touchDown = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didMiss)];
    touchDown.numberOfTapsRequired = 1;
    [backgroundV addGestureRecognizer:touchDown];
    
    height = 470;
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, height+50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [window addSubview:bottomView];
    [WMZDialogTool setView:bottomView Radii:CGSizeMake(18, 18) RoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:kSemBoldFont(18)];
    [titleLabel setTextColor:lwColorBlack];
    titleLabel.text = title;
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(35);
        make.centerX.equalTo(bottomView.mas_centerX);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"home_money"]];
    [bottomView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(preLeft);
        make.top.equalTo(bottomView.mas_top).offset(177/2);
        make.width.height.equalTo(@24);
    }];

    UILabel *amountLabel = [[UILabel alloc] init];
    [amountLabel setFont:kMediumFont(16)];
    [amountLabel setTextColor:lwColorBlack];
    NSString *turePrice = [NSString stringWithFormat:@"%@",@(amount.floatValue * [LWPublicManager getCurrentPriceWithTokenType:TokenTypeBSV].floatValue)];
    amountLabel.text = [NSString stringWithFormat:@"%@BSV≈¥%@",amount,turePrice];
    [bottomView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(7.5);
        make.centerY.equalTo(imageView.mas_centerY);
    }];

    UILabel *receiveLabel = [[UILabel alloc] init];
    [receiveLabel setFont:kSemBoldFont(18)];
    [receiveLabel setTextColor:lwColorBlack];
    receiveLabel.text = @"收款方";
    [bottomView addSubview:receiveLabel];
    [receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(35);
        make.left.equalTo(bottomView.mas_left).offset(preLeft);
    }];

    UILabel *payMailT = [[UILabel alloc] init];
    [payMailT setFont:kFont(16)];
    [payMailT setTextColor:lwColorBlackPure];
    payMailT.text = @"paymail:";
    [bottomView addSubview:payMailT];
    [payMailT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receiveLabel.mas_bottom).offset(6.5);
        make.left.equalTo(bottomView.mas_left).offset(preLeft);
    }];
    
    UILabel *payMailLabel = [[UILabel alloc] init];
    [payMailLabel setFont:kFont(16)];
    [payMailLabel setTextColor:lwColorBlack];
    payMailLabel.text = payMail;
    payMailLabel.textAlignment = NSTextAlignmentRight;
    payMailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [bottomView addSubview:payMailLabel];
    [payMailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payMailT.mas_centerY);
        make.right.equalTo(bottomView.mas_right).offset(-preLeft);
        make.left.lessThanOrEqualTo(payMailT.mas_right);
    }];

    UILabel *addressT = [[UILabel alloc] init];
    [addressT setFont:kFont(16)];
    [addressT setTextColor:lwColorBlackPure];
    addressT.text = @"address:";
    [bottomView addSubview:addressT];
    [addressT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payMailT.mas_bottom).offset(9);
        make.left.equalTo(bottomView.mas_left).offset(preLeft);
    }];

    UILabel *addressLabel = [[UILabel alloc] init];
    [addressLabel setFont:kFont(16)];
    [addressLabel setTextColor:lwColorBlack];
    addressLabel.text = address;
    addressLabel.textAlignment = NSTextAlignmentRight;
    addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [bottomView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressT.mas_centerY);
        make.right.equalTo(bottomView.mas_right).offset(-preLeft);
        make.left.lessThanOrEqualTo(bottomView.mas_left).offset(156/2);
    }];

    UIImageView *faceImgV = [[UIImageView alloc] init];
    [faceImgV setImage:[UIImage imageNamed:@"home_FaceID"]];
    [bottomView addSubview:faceImgV];
    [faceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.top.equalTo(addressLabel.mas_bottom).offset(57/2);
        make.width.height.equalTo(@41);
    }];

    UILabel *attentionLabel = [[UILabel alloc] init];
    [attentionLabel setFont:kMediumFont(16)];
    [attentionLabel setTextColor:lwColorBlackLight];
    attentionLabel.text = @"请用人脸识别授权";
    [bottomView addSubview:attentionLabel];
    [attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.top.equalTo(faceImgV.mas_bottom).offset(18);
    }];
    
    CGFloat buttonWidth = (kScreenWidth - preLeft*2 - 31)/2;
    LWCommonBottomBtn *cancleButton = [[LWCommonBottomBtn alloc] init];
    cancleButton.frame = CGRectMake(0, 0, buttonWidth, 50);
    cancleButton.selected = NO;
    [cancleButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(didMiss) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attentionLabel.mas_bottom).offset(30);
        make.left.equalTo(bottomView.mas_left).offset(preLeft);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@50);
    }];
    
    LWCommonBottomBtn *sendButton = [[LWCommonBottomBtn alloc] init];
    sendButton.frame = CGRectMake(0, 0, buttonWidth, 50);
    sendButton.frame = CGRectMake(0, 0, buttonWidth, 50);
    sendButton.selected = YES;
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(didTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendButton];
    objc_setAssociatedObject (sendButton , &keyOfMethod, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancleButton.mas_centerY);
        make.right.equalTo(bottomView.mas_right).offset(-preLeft);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@50);
    }];
    
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.toValue = @(bottomView.center.y-height);
    anSpring.springBounciness = 7.0f;
    //    anSpring.springSpeed = 10.0f;
    [bottomView pop_addAnimation:anSpring forKey:@"position"];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        backgroundV.backgroundColor = RGBA(0, 0, 0, 0.3);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)didTitleBtnTouchDragOutsid:(UIButton*)btn{
    
    btn.backgroundColor = [UIColor clearColor];
}
-(void)didTitleBtnTouchDragInside:(UIButton*)btn{
    btn.backgroundColor = RGBA(245, 245, 245, 1);
}
//点击事件
-(void)didTitleBtn:(UIButton*)btn{
    
    btn.backgroundColor = [UIColor clearColor];
    
    [[TDTouchID sharedInstance] td_showTouchIDWithDescribe:@"通过Home键验证已有指纹" FaceIDDescribe:@"通过已有面容ID验证" BlockState:^(TDTouchIDState state, NSError *error) {
        if (state == TDTouchIDStateNotSupport) {    //不支持TouchID/FaceID
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"当前设备不支持生物验证,请打开生物识别" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (@available(iOS 10.0, *)){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }else{
                    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }

            }];
            [alertVC addAction:alertAc];
            [LogicHandle presentViewController:alertVC animate:YES];
        } else if (state == TDTouchIDStateSuccess) {    //TouchID/FaceID验证成功
            //获取关联
            LWPayBlock block1 = (LWPayBlock)objc_getAssociatedObject(btn, &keyOfMethod);
            if(block1){
                [WMHUDUntil showMessageToWindow:@"Send"];
                block1(YES);
            }
            
        } else if (state == TDTouchIDStateInputPassword) { //用户选择手动输入密码

        }
    }];

}

//页面消失
-(void)didMiss{
    [UIView animateWithDuration:0.3 animations:^{
        backgroundV.backgroundColor = RGBA(0, 0, 0, 0);
        bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, height+50);
    } completion:^(BOOL finished) {
        [backgroundV removeFromSuperview];
        [bottomView removeFromSuperview];
    }];
    
    
}



@end
