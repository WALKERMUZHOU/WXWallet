//
//  LWLoginViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/12.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginViewController.h"
#import "LWInputTextField.h"
#import "LWCommonBottomBtn.h"
#import "LWLoginCoordinator.h"
#import "LWRocoveryViewController.h"
#import "PublicKeyView.h"
#import "PubkeyManager.h"

@interface LWLoginViewController ()

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) LWInputTextField   *textField;
@property (nonatomic, strong) NSString *emailStr;

@end

@implementation LWLoginViewController

- (instancetype)initWithEmailStr:(NSString *)emailStr{
    self = [super init];
    if (self) {
        self.emailStr = emailStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    return;
    [self initPubKey];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];

         LWTrusteeModel *model = [array objectAtIndex:0];
         NSString *prikey = [PubkeyManager getPrikey];
           
        NSString *pubkey = model.publicKey;
        NSString *data = @"7a46de356a1c77557474f57a3917ef0ecc2065068fa639fc2fea59020e66a904a7ffe6cfcbad89b105478699dd5fc25757f0d9fe3bab0b43c1b5878348ea290216e479edee7b81684e0ed5d350f5f2ac3175e9328ca90571dadf10115853e99513cf060196588313fc878c9bb78e7a830e1d85314270a9e57669facd7bbbbde1b7531c60f1c9ec85dc0465897def401a6c4bd9ff2e02df82ff372429aa805898b77ea7204df3c2ea02d7d5276a2c67bb608da7d39b08067aa1f7c472bf309c440d25a75fefab1037015f0220fac727b581c8b73568cc141df6319ee866d7b03a6622947c5ae599a8675f6236ce8b0f51dbec6fb7a98a5b634abb9a23e675def1aea31fe28af07f879ec7ea59970bf5d50c394392564d99f7a5f1572f8977049bed6c1356fc79db6fd2fc89bdeacffe89";
            NSString *encirptStr = [PubkeyManager getencriptwithPrikey:prikey andPubkey:pubkey adnMessage:data];

//        [LWLoginCoordinator verifyRecoveryEmailCodeWithCode:@"66666666" andModel:model WithSuccessBlock:^(id  _Nonnull data) {
//            NSLog(@"data%@",[data objectForKey:@"data"]);
//            NSString *encirptStr = [PubkeyManager getencriptwithPrikey:prikey andPubkey:pubkey adnMessage:data[data]];
//
//
//        } WithFailBlock:^(id  _Nonnull data) {
//
//        }];
    });

    
//    [PubkeyManager getencriptwithPrikey:nil andPubkey:nil adnMessage:nil];
//    [[PublicKeyView shareInstance] getInitDataBlock:^(NSDictionary * _Nonnull dicData) {
//        NSLog(@"%@",dicData);
//    }];
}

- (void)createUI{
    self.title = @"验证邮箱";
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = lwColorBlack1;
    [self.view addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = kSemBoldFont(16);
    self.titleLabel.text = @"你需要绑定邮箱并且备份钱包之后才可以进行";
    NSLog(@"navi:%ld",(long)kNavigationBarHeight);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20 + kNavigationBarHeight);
        make.left.equalTo(self.view.mas_left).offset(19);
        make.right.equalTo(self.view.mas_right).offset(-19);
    }];
    
    CGFloat preLeft = 13.f;
    self.textField = [[LWInputTextField alloc] initWithFrame:CGRectMake(preLeft, 0, kScreenWidth- preLeft*2, 50) andType:LWInputTextFieldTypeRightBtn];
    self.textField.lwTextField.placeholder = @"请输入邮箱";
    self.textField.lwTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.textField.button setTitle:@"Next" forState:UIControlStateNormal];
    [self.textField.button setTitleColor:lwColorNormal forState:UIControlStateNormal];
    [self.view addSubview:self.textField];
    __weak typeof(self) weakSelf = self;
    self.textField.buttonBlock = ^{
        [weakSelf buttonClick];
    };
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.titleLabel.mas_bottom).offset(76);
       make.left.equalTo(self.view.mas_left).offset(13);
       make.right.equalTo(self.view.mas_right).offset(-13);
    make.height.equalTo(@50);
    }];
    
    if (self.emailStr) {
        self.titleLabel.text = [NSString stringWithFormat:@"验证链接发送到了您的以下邮箱%@，请复制验证码到下面的验证框进行验证",_emailStr];
        [self.textField.button setTitle:@"Verify" forState:UIControlStateNormal];
        self.textField.lwTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    [self initPubKey];
}

- (void)initPubKey{
    NSDictionary *pubDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    if (pubDic && pubDic.allKeys.count>0) {
        return;
    }
    
    [[PublicKeyView shareInstance] getInitDataBlock:^(NSDictionary * _Nonnull dicData) {
        if (dicData) {
            [[NSUserDefaults standardUserDefaults] setObject:dicData forKey:kAppPubkeyManager_userdefault];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [self initPubKey];
        }
    }];
}

#pragma mark - method
- (void)buttonClick{

    if (self.loginVCType == LWLoginVCTypeCheckCode) {
        [self verifyEmailClick];
    }else{
        [self getEmailCodeClick];
    }
}

- (void)getEmailCodeClick{
    [SVProgressHUD show];
    NSString *emailStr = self.textField.lwTextField.text;
    [LWLoginCoordinator getSMSCodeWithEmail:emailStr WithSuccessBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:@"验证码发送成功"];
        [self jumpToVerifyVC];
    } WithFailBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:@"获取验证码失败"];
    }];
}

- (void)verifyEmailClick{
    [SVProgressHUD show];
    [LWLoginCoordinator verifyEmailCodeWithEmail:self.emailStr andCode:self.textField.lwTextField.text WithSuccessBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        if (data == NO) {
            [WMHUDUntil showMessageToWindow:@"验证失败"];
            return ;
        }
        NSDictionary *dataDic = [data objectForKey:@"data"];
        if(dataDic && dataDic.allKeys.count>0){
            [[LWUserManager shareInstance] setUserDic:dataDic];
            [[LWUserManager shareInstance] setEmail:self.emailStr];
            if([[LWUserManager shareInstance] getUserModel].uid.length>0){//老用户
                [self jumpToRecoveryVC];
            }else{
    //            [self registerMethod];
            }
        }else{
            [WMHUDUntil showMessageToWindow:@"验证失败"];
        }

        
    } WithFailBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
    }];
}

- (void)jumpToVerifyVC{
    LWLoginViewController *loginVC = [[LWLoginViewController alloc]initWithEmailStr:self.textField.lwTextField.text];
    loginVC.loginVCType = LWLoginVCTypeCheckCode;
    [self.navigationController pushViewController:loginVC animated:YES];

}

- (void)jumpToRecoveryVC{
    LWRocoveryViewController *recovery = [[LWRocoveryViewController alloc]init];
    [self.navigationController pushViewController:recovery animated:YES];
}

- (void)jumpToRegisterVC{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getksdjhasdh{
    NSArray *dataArray = @[@"c0648c9d6bfe2742ed6aba859aee4e6dd620c9948919c591b8e05023c16461a538378d754b5e9ecf5aac4cf1ee07d45a370fd5a394599f6339546db3982c11407349abfa5cafd10927ce4ec876928abf2f2be7d24ef97bcffcf08c103623449db51b2255e19d9e0ea6ec15d6a028e4233ac27064d1323c28c6cce197b889d93f4892cbd1a57c189415beea6d2b4b5c6f5f99b36f2006d286d2b30104b9d6d1b5887baf781b41f3a3258cddb4a817dee9a25ff021febc25b53d24d0d56ccca869468941fc7184b426bb0f5c31ad50edecb436e40c30f930b5d42ba94e442329a2d1fe77c3cc8032495939726b2b9e8d3ba4c07a9e49fbbaf83fe74810f60bbe4654c6c3c833fa4edf2d8629a6da9e3ac44a60228eee543fbfaf3b3dcca9e740785829f9189d4816a4306dbbafe34e6b7d",@"832cd70f1c47d0fa3860676cc6a5b3a4b3466443f750d9df52094b796a18df9e1d8f9424d343429da87b7d1031b37107309ccde234c3f672f2a77e012599e150eb1fed03728de8307166e3c89e0763abf2691d4360e1eaec3023a1ce4f9857b0f0c5f197f5e93b034c9c001eea63f7cc7049bfb5fc2cae93781e03198756461bac9890be8d302418a0e94c2ac2102ac5e280b86a6a8aacfd8e758b3b21fc177310a61f5c51863ae24d7781846068382b2dde7cb4fb130fdcd76b7d46f17fd5160e5958f58d19f3839e538ab1840e7c7af180ba4ff5ee85e7c5de629cfd70e06822c2eb04e4d63e0a2f44ff357a47b45756f39999ca7dc07983172e3fa32f7f3e46d66d21823d1ae770871b306acd39e6fa1ad7d9759ab9e48d45f5345cbe8da00f6dd5d5021619e962e065f907a3d6b8"
                           ];
    NSString *privateStr = @"53759814570ad5ee6e7859b7280e2be4345f13ddf6a7cbd2058dbac022d42a58";
    NSString *publicStr = @"03093b9db836a833554bacdf9f6aadb5dd2048d202caefc4a5e8cb6a63a89ef8d5";

//    NSString *encirptStr = [PubkeyManager getencriptwithPrikey:privateStr andPubkey:publicStr adnMessage:dataArray[0]];
    
    [self calculateSeed:dataArray];
}

- (void)calculateSeed:(NSArray *)dataArray{
    NSString *prikey = [PubkeyManager getPrikey];
    NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];

    NSMutableArray *mutableDecripArr = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        for (NSInteger i = 0; i<dataArray.count; i++) {

            LWTrusteeModel *model = [array objectAtIndex:i];
            NSString *pubkey = model.publicKey;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [PubkeyManager getdecriptwithPrikey:prikey andPubkey:pubkey adnMessage:dataArray[i] WithSuccessBlock:^(id  _Nonnull data) {
                                [mutableDecripArr addObject:(NSString *)data];
                                if(i == dataArray.count-1){
                                    [SVProgressHUD dismiss];
                                    [self getRecoverData:mutableDecripArr];
                                    NSLog(@"success:\n%@",mutableDecripArr);
                                }
                    dispatch_semaphore_signal(signal);// 发送信号下面的代码一定要写在赋值完成的下面
                } WithFailBlock:^(id  _Nonnull data) {
                    [SVProgressHUD dismiss];
                    dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
                    return ;
                }];
            });
        }
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    });

    
////    id seedObject = [PubkeyManager getRecoverData:mutableDecripArr];
//    [SVProgressHUD dismiss];
//    NSLog(@"recoverSuccess");
}

- (void)getRecoverData:(NSArray *)recoverArr{
    [PubkeyManager getRecoverData:recoverArr WithSuccessBlock:^(id  _Nonnull data) {
        
    } WithFailBlock:^(id  _Nonnull data) {
        
    }];
}

@end
