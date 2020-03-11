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
#import "libthresholdsig.h"
#import "LWFaceBindViewController.h"
#import "LWAddressTool.h"

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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initPubKey];
}

- (void)createUI{
//    self.title = @"验证邮箱";
    self.title = NSLocalizedString(@"home_email_verify", nil);
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppPubkeyManager_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)initPubKey{
    /**
     pk = 03c3e9f91e5197497a14f95f35771c2037964901fba1a3e2737210ce3b66123e;
     publicKey = 028f9070f066e9e1982519edb23fd4fa5d0cd7d467f51dff8b4f67c3c9f8daeb8d;
     secret = 1e755f5b4540a5308b8ed6cd8349265a39e611e56393736162844dfbf1f8e2bf;
     seed = "rookie hold potato sense fish receive atom neglect win express credit task";
     shares =     (
         8013da6163c723ae734e7bcb529e5e5462b337c2330f1e4913a4b09b62259624cadd73cf362f31e068ac7a0b49699dad24dd2784128f1032c90b4c1fc5798e312d5d146975bd4b3f04739e21a210c20b3f376411fccdc046cdbe3406e488310752bd36a322dbc7049d0a1f4bc5b7e8e47d0fb446816e6908b3a6fb00b483c7c55d2fc44c62d6ad3ff87ff886778d75398d029236d7063,
         80279519178717470684f6517524bd73756caf8e96069d59a74f612e44427c4374725786bc4733ca309f35dc73194a9209ad9f01e505a06f73dc19f4cae82db96b7df8c84b6047b618ed1d95442b740e1fb57829185000877ab4d80bc90a3207f5600d4ce5a05e03dbdcaf5d7b653011bbd8b88612c4d3da874427da790e8f8cab94988255a65bb5b13830d61f008a690bde3466be050
     );
     sig = "";
     xpub = xpub661MyMwAqRbcFVC3723tb7Xxpm9grwU8wAmsXwYfSBUKaqysePoYm238BRQHaRg8tQt49Xm4VUmgn1cyC4KVy1yK28LzySCUeXtgGf4ZedA;
     */
    
    [LWPublicManager getInitData];
    
//    [[PublicKeyView shareInstance] getInitDataBlock:^(NSDictionary * _Nonnull dicData) {
//        if (dicData) {
//            [[NSUserDefaults standardUserDefaults] setObject:dicData forKey:kAppPubkeyManager_userdefault];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }else{
//            [self initPubKey];
//        }
//    }];
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
        id dataID = [data objectForKey:@"data"];
        if (![dataID isKindOfClass:[NSDictionary class]]) {
            if (dataID == NO || [dataID integerValue] == 0) {
                 [SVProgressHUD dismiss];
                 [WMHUDUntil showMessageToWindow:@"验证失败"];
                 return ;
             }
        }
 
        NSDictionary *dataDic = (NSDictionary *)dataID;
        if(dataDic && dataDic.allKeys.count>0){
            [[LWUserManager shareInstance] setUserDic:dataDic];
            [[LWUserManager shareInstance] setEmail:self.emailStr];
            if([[LWUserManager shareInstance] getUserModel].uid.length>0){//老用户
                [SVProgressHUD dismiss];
                [self jumpToRecoveryVC];
            }else{
                [self registerMethod];
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

- (void)registerMethod{
    [SVProgressHUD show];
    [PubkeyManager getPubKeyWithEmail:self.emailStr SuccessBlock:^(id  _Nonnull data) {
        
        NSString *pk = [data objectForKey:@"pk"];
        
        NSString *dpStr = [NSString stringWithFormat:@"%s",get_random_key_pair()];
        NSData * jsonData = [dpStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *dpArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

        NSString *secret = [data objectForKey:@"secret"];
        
        NSArray *trusteeArrar = [[LWTrusteeManager shareInstance] getTrusteeArray];
        NSArray *shares = [data objectForKey:@"shares"];
        
        NSMutableDictionary *sharesDic = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < trusteeArrar.count; i++) {
            LWTrusteeModel *model = trusteeArrar[i];
            NSString *encriData = [LWEncryptTool encryptWithPk:pk pubkey:model.publicKey andMessage:shares[i]];
            [sharesDic setObj:encriData forKey:model.name];
             if (i == trusteeArrar.count - 1){
                 [self manageDkWithSecret:secret andpJoin:dpArray andShares:sharesDic andinfoDic:data];
             }
            
            
//            [PubkeyManager encriptwithPrikey:pk andPubkey:model.publicKey adnMessage:shares[i] WithSuccessBlock:^(id  _Nonnull encriData) {
//                [sharesDic setObj:encriData forKey:model.name];
//                if (i == trusteeArrar.count - 1){
//                    [self manageDkWithSecret:secret andpJoin:dpArray andShares:sharesDic andinfoDic:data];
//                }
//            } WithFailBlock:^(id  _Nonnull data) {
//
//            }];
        }
        
    } WithFailBlock:^(id  _Nonnull data) {
        
    }];

}

- (void)manageDkWithSecret:(NSString *)secret andpJoin:(NSArray *)dpArray andShares:(NSDictionary *)encryptShares andinfoDic:(NSDictionary *)data{
    
    NSString *d = dpArray.firstObject;
    NSString *p = dpArray.lastObject;
    
    NSString *ek = [NSString stringWithFormat:@"%s",get_encryption_key([d cStringUsingEncoding:NSASCIIStringEncoding], [p cStringUsingEncoding:NSASCIIStringEncoding])];
    NSString *sig = [data objectForKey:@"sig"];
    NSString *xpub = [data objectForKey:@"xpub"];
    NSString *encryptStr = [LWEncryptTool encrywithTheKey:secret message:dpArray andHex:1];
    NSDictionary *params = @{@"email":self.emailStr,
                             @"xpub":xpub,
                             @"sig":sig,
                             @"ek":ek,
                             @"dk":encryptStr,
                             @"shares":encryptShares,
                             @"token":[[LWUserManager shareInstance] getUserModel].token
    };
    [self loginRequestWithParams:params];
    
//    [PubkeyManager getDkWithSecret:secret andpJoin:dpArray SuccessBlock:^(id  _Nonnull data) {
//        NSDictionary *params = @{@"email":self.emailStr,
//                                 @"xpub":xpub,
//                                 @"sig":sig,
//                                 @"ek":ek,
//                                 @"dk":data,
//                                 @"shares":encryptShares,
//                                 @"token":[[LWUserManager shareInstance] getUserModel].token
//        };
//        [self loginRequestWithParams:params];
//    } WithFailBlock:^(id  _Nonnull data) {
//
//    }];
}

- (void)loginRequestWithParams:(NSDictionary *)loginParams{
    [LWLoginCoordinator registerUserWithParams:loginParams WithSuccessBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        LWUserModel *model = [[LWUserManager shareInstance] getUserModel];
        model.uid = [data objectForKey:@"uid"];
        model.secret = [data objectForKey:@"secret"];
        model.login_token = [data objectForKey:@"login_token"];
        [[LWUserManager shareInstance] setUser:model];
        
        LWFaceBindViewController *lwfaceVC = [[LWFaceBindViewController alloc]init];
        [self.navigationController pushViewController:lwfaceVC animated:YES];
        
    } WithFailBlock:^(id  _Nonnull data) {
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:@"fail"];
    }];
}


@end
