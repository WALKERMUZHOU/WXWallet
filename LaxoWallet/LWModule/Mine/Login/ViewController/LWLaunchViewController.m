//
//  LWLaunchViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/14.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLaunchViewController.h"
#import "LWCommonBottomBtn.h"
#import "TDTouchID.h"

@interface LWLaunchViewController ()

@end

@implementation LWLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self faceIDCheck];
}

- (void)createUI{
    LWCommonBottomBtn *bottomBtn = [[LWCommonBottomBtn alloc]init];
    [bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.tag = 1000;
    [bottomBtn setTitle:@"Open App" forState:UIControlStateNormal];
    bottomBtn.selected = YES;
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@(50));
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
//    LWCommonBottomBtn *bottomBtn1 = [[LWCommonBottomBtn alloc]init];
//    [bottomBtn1 addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
//    bottomBtn1.tag = 1001;
//    [bottomBtn1 setTitle:@"重新登录" forState:UIControlStateNormal];
//    bottomBtn1.selected = YES;
//    [self.view addSubview:bottomBtn1];
//    [bottomBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(12);
//        make.right.equalTo(self.view.mas_right).offset(-12);
//        make.height.equalTo(@(50));
//        make.top.equalTo(bottomBtn.mas_bottom).offset(30);
//    }];
}

- (void)bottomClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        [self faceIDCheck];
    }else{
        [[LWUserManager shareInstance] clearUser];
        [LogicHandle showLoginVC];
    }
}

- (void)faceIDCheck{
    TDTouchIDSupperType type = [[TDTouchID sharedInstance] td_canSupperBiometrics];
    if (type == TDTouchIDSupperTypeNone) {
        [LogicHandle showTabbarVC];
        return;
    }
    
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
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
        } else if (state == TDTouchIDStateSuccess) {    //TouchID/FaceID验证成功
            [LogicHandle showTabbarVC];
        } else if (state == TDTouchIDStateInputPassword) { //用户选择手动输入密码
//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"当前设备不支持生物验证" message:@"请输入密码来验证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            alertview.alertViewStyle = UIAlertViewStyleSecureTextInput;
//            [alertview show];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
