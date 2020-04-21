//
//  LWLoginStepSuccessView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepSuccessView.h"
#import "TDTouchID.h"
#import <GTSDK/GeTuiSdk.h>
@implementation LWLoginStepSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)successClick:(UIButton *)sender {
    
    [GeTuiSdk bindAlias:@"iOS" andSequenceNum:kGTSequenceUid.md5String];
    
    
        TDTouchIDSupperType type = [[TDTouchID sharedInstance] td_canSupperBiometrics];
        switch (type) {
            case TDTouchIDSupperTypeFaceID:
                NSLog(@"😄支持FaceID");
                break;
            case TDTouchIDSupperTypeTouchID:
                NSLog(@"😄支持TouchID");
                break;
            case TDTouchIDSupperTypeNone:{
//                [[NSUserDefaults standardUserDefaults] setObject:@"None" forKey:kAppTouchIdStart_userdefault];
//                 [[LWUserManager shareInstance] setLoginSuccess];
//                 [[NSUserDefaults standardUserDefaults] synchronize];
//                 [LogicHandle showTabbarVC];
            }
                NSLog(@"😭不支持生物验证");
                break;
            default:
                break;
        }

        [[TDTouchID sharedInstance] td_showTouchIDWithDescribe:NSLocalizedString(@"face_title_TouchID", nil) FaceIDDescribe:NSLocalizedString(@"face_title_FaceID", nil) BlockState:^(TDTouchIDState state, NSError *error) {
            if (state == TDTouchIDStateNotSupport) {    //不支持TouchID/FaceID
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"face_no_biometric", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"common_sure", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
//                    #define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
//                    if (iOS10) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
//                    } else {
//                        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"None" forKey:kAppTouchIdStart_userdefault];
                     [[LWUserManager shareInstance] setLoginSuccess];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [LogicHandle showTabbarVC];
                    
                    
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
                [[NSNotificationCenter defaultCenter] postNotificationName:KUserAccountLogIn object:nil];
                
                [LogicHandle showTabbarVC];
            } else if (state == TDTouchIDStateInputPassword) { //用户选择手动输入密码
    //            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"当前设备不支持生物验证" message:@"请输入密码来验证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //            alertview.alertViewStyle = UIAlertViewStyleSecureTextInput;
    //            [alertview show];
            }
        }];
    
    
}

@end
