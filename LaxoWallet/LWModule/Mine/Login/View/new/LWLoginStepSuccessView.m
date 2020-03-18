//
//  LWLoginStepSuccessView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepSuccessView.h"
#import "TDTouchID.h"

@implementation LWLoginStepSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)successClick:(UIButton *)sender {
    
        TDTouchIDSupperType type = [[TDTouchID sharedInstance] td_canSupperBiometrics];
        switch (type) {
            case TDTouchIDSupperTypeFaceID:
                NSLog(@"😄支持FaceID");
                break;
            case TDTouchIDSupperTypeTouchID:
                NSLog(@"😄支持TouchID");
                break;
            case TDTouchIDSupperTypeNone:{
                [[NSUserDefaults standardUserDefaults] setObject:@"None" forKey:kAppTouchIdStart_userdefault];
                 [[LWUserManager shareInstance] setLoginSuccess];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 [LogicHandle showTabbarVC];
            }
                NSLog(@"😭不支持生物验证");
                break;
            default:
                break;
        }

        [[TDTouchID sharedInstance] td_showTouchIDWithDescribe:@"通过Home键验证已有指纹" FaceIDDescribe:@"通过已有面容ID验证" BlockState:^(TDTouchIDState state, NSError *error) {
            if (state == TDTouchIDStateNotSupport) {    //不支持TouchID/FaceID
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"当前设备不支持生物验证,请打开生物识别" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    #define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
                    if (iOS10) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
                [alertVC addAction:alertAc];
                [LogicHandle presentViewController:alertVC animate:YES];
//                [self presentViewController:alertVC animated:YES completion:nil];
                
                
            } else if (state == TDTouchIDStateSuccess) {    //TouchID/FaceID验证成功
                if (type == TDTouchIDSupperTypeFaceID) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"FaceID" forKey:kAppTouchIdStart_userdefault];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"TouchID" forKey:kAppTouchIdStart_userdefault];
                }
                [[LWUserManager shareInstance] setLoginSuccess];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [LogicHandle showTabbarVC];
            } else if (state == TDTouchIDStateInputPassword) { //用户选择手动输入密码
    //            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"当前设备不支持生物验证" message:@"请输入密码来验证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //            alertview.alertViewStyle = UIAlertViewStyleSecureTextInput;
    //            [alertview show];
            }
        }];
    
    
}

@end
