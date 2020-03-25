//
//  LWFaceBindViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWFaceBindViewController.h"
#import "LWCommonBottomBtn.h"
#import "TDTouchID.h"

@interface LWFaceBindViewController ()
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, assign) TDTouchIDSupperType idType;
@end

@implementation LWFaceBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    [self createUI];
}

- (void)createUI{
    self.title = @"绑定FaceID";

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = lwColorBlack1;
    [self.view addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = kSemBoldFont(16);
    self.titleLabel.text = @"开启人脸识别可以确保只有你才可以开启钱包";
    NSLog(@"navi:%ld",(long)kNavigationBarHeight);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(140 + kNavigationBarHeight);
        make.left.equalTo(self.view.mas_left).offset(13);
        make.right.equalTo(self.view.mas_right).offset(-13);
    }];
    
    LWCommonBottomBtn *bottomBtn = [[LWCommonBottomBtn alloc]init];
    [bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.tag = 1000;
    [bottomBtn setTitle:@"开启人脸识别" forState:UIControlStateNormal];
    bottomBtn.selected = YES;
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@(50));
    }];
    TDTouchIDSupperType type = [[TDTouchID sharedInstance] td_canSupperBiometrics];
    self.idType = type;
    switch (type) {
        case TDTouchIDSupperTypeFaceID:
            NSLog(@"😄支持FaceID");
            self.title = @"绑定FaceID";
            break;
        case TDTouchIDSupperTypeTouchID:
            NSLog(@"😄支持TouchID");
            self.title = @"绑定TouchID";
            self.titleLabel.text = @"开启指纹识别可以确保只有你才可以开启钱包";
            [bottomBtn setTitle:@"开启指纹识别" forState:UIControlStateNormal];
            break;
        case TDTouchIDSupperTypeNone:
            NSLog(@"😭不支持生物验证");
            break;
        default:
            break;
    }
    
}

- (void)bottomClick:(UIButton *)sender{
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

    [[TDTouchID sharedInstance] td_showTouchIDWithDescribe:@"Verify existing fingerprints through the Home button" FaceIDDescribe:@"Verify with existing face ID" BlockState:^(TDTouchIDState state, NSError *error) {
        if (state == TDTouchIDStateNotSupport) {    //不支持TouchID/FaceID
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Current device does not support biometric verification, please turn on biometrics" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAc = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                #define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
                if (iOS10) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            [alertVC addAction:alertAc];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
