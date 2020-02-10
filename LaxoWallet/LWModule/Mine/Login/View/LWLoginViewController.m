//
//  LWLoginViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginViewController.h"

#import "LWLoginCoordinator.h"

#import "LWRecoveryView.h"
#import "LWLoginSecondStepView.h"

@interface LWLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getTrueteeData];

}

- (void)getTrueteeData{
    [SVProgressHUD show];
    [LWLoginCoordinator getTrueteeDataWithSuccessBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        
        NSArray *trustArray = [[LWTrusteeManager shareInstance] getTrusteeArray];

        NSLog(@"%@",trustArray);
    } WithFailBlock:^(id  _Nonnull data) {
        [self getTrueteeData];
    }];
}

- (IBAction)smsCodeBtnClick:(UIButton *)sender {
    
    if(_emailTF.text.length>0){
        NSString *emailStr = self.emailTF.text;
        [LWLoginCoordinator getSMSCodeWithEmail:emailStr WithSuccessBlock:^(id  _Nonnull data) {
            [WMHUDUntil showMessageToWindow:@"验证码发送成功"];
        } WithFailBlock:^(id  _Nonnull data) {
            [WMHUDUntil showMessageToWindow:@"获取验证码失败"];
        }];
    }else{
        [WMHUDUntil showMessageToWindow:@"请输入邮箱"];
    }
}

- (IBAction)loginClick:(UIButton *)sender {
    if (!_emailTF || _emailTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"请输入邮箱"];
        return;
    }
    
    if (!_pswTF || _pswTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"请输入验证码"];
        return;
    }
    
    [LWLoginCoordinator verifyEmailCodeWithEmail:_emailTF.text andCode:_pswTF.text WithSuccessBlock:^(id  _Nonnull data) {
        NSDictionary *dataDic = [data objectForKey:@"data"];
        [[LWUserManager shareInstance] setUserDic:dataDic];
        if([[LWUserManager shareInstance] getUserModel].uid.length>0){//老用户
            [self showRecoveryView];
        }else{
            [self registerMethod];
        }
        
    } WithFailBlock:^(id  _Nonnull data) {

    }];

    
}

- (void)registerMethod{
    //注册
    //展示注册页面
}

- (void)showRegisterView{
    LWLoginSecondStepView *secondView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWLoginSecondStepView class]) owner:nil options:nil].lastObject;
    secondView.frame = self.view.bounds;
    [self.view addSubview:secondView];
}

- (void)showRecoveryView{
    LWRecoveryView *secondView = [[LWRecoveryView alloc]init];
    secondView.backgroundColor = [UIColor whiteColor];
    secondView.frame = self.view.bounds;
    [self.view addSubview:secondView];
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
