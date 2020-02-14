//
//  LWRocoveryViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/12.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWRocoveryViewController.h"
#import "LWCommonBottomBtn.h"
#import "LWLoginCoordinator.h"
#import "LWRecoveryTrustholdViewController.h"
#import "PublicKeyView.h"
#import "PubkeyManager.h"

@interface LWRocoveryViewController ()

@end

@implementation LWRocoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"恢复钱包";
    
    LWCommonBottomBtn *bottomBtn = [[LWCommonBottomBtn alloc]init];
    [bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.tag = 1000;
    [bottomBtn setTitle:@"上传二维码恢复钱包" forState:UIControlStateNormal];
    bottomBtn.selected = YES;
    [self.view addSubview:bottomBtn];
    
    LWCommonBottomBtn *bottomBtn1 = [[LWCommonBottomBtn alloc]init];
    [bottomBtn1 addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn1 setTitle:@"通过Trusthold恢复" forState:UIControlStateNormal];
    bottomBtn1.selected = YES;
    bottomBtn1.tag = 1001;
    [self.view addSubview:bottomBtn1];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(195+kNavigationBarHeight);
        make.left.equalTo(self.view.mas_left).offset(13);
        make.right.equalTo(self.view.mas_right).offset(-13);
        make.height.equalTo(@50);
    }];
    
    [bottomBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBtn.mas_bottom).offset(81);
        make.left.equalTo(self.view.mas_left).offset(13);
        make.right.equalTo(self.view.mas_right).offset(-13);
        make.height.equalTo(@50);
    }];
    
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

- (void)bottomClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        //二维码恢复验证
    }else{
        //短信验证
        [self trustholdVerify];
    }
}

- (void)trustholdVerify{
//    [self testbitmesh];
//    return;
    [SVProgressHUD show];
    NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        for (NSInteger i = 0; i<array.count; i++) {
             
            LWTrusteeModel *model = [array objectAtIndex:i];
            [LWLoginCoordinator getRecoverySMSCodeWithModel:model SuccessBlock:^(id  _Nonnull data) {
//                if (i == 0) {
//                    [self jumpToTrustholdVC];
//                     [WMHUDUntil showMessageToWindow:@"验证码发送成功"];
//                    return ;
//                }
                if (i == array.count - 1) {
                       [self jumpToTrustholdVC];
                       [WMHUDUntil showMessageToWindow:@"验证码发送成功"];
                   }
                  dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
              } WithFailBlock:^(id  _Nonnull data) {
                  [WMHUDUntil showMessageToWindow:@"请求失败"];
                  dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
                  return ;
              }];
             dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
         }
    });
}

- (void)jumpToTrustholdVC{
    LWRecoveryTrustholdViewController *trustholdVC = [[LWRecoveryTrustholdViewController alloc]init];
    [self.navigationController pushViewController:trustholdVC animated:YES];
}


- (void)testbitmesh{
    NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];
    NSString *prikey = [PubkeyManager getPrikey];
    
    LWTrusteeModel *model = [array objectAtIndex:0];
    NSString *pubkey = model.publicKey;
    
    [LWLoginCoordinator getRecoverySMSCodeWithModel:model SuccessBlock:^(id  _Nonnull data) {
        
        [self testBitmeshRecover];
     } WithFailBlock:^(id  _Nonnull data) {
         [WMHUDUntil showMessageToWindow:@"请求失败"];
    
     }];
}

- (void)testBitmeshRecover{
    NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];

    LWTrusteeModel *model = [array objectAtIndex:0];
    NSString *prikey = [PubkeyManager getPrikey];
      
      NSString *pubkey = model.publicKey;
   [LWLoginCoordinator verifyRecoveryEmailCodeWithCode:@"66666666" andModel:model WithSuccessBlock:^(id  _Nonnull data) {
       NSLog(@"data%@",[data objectForKey:@"data"]);
       NSString *encirptStr = [PubkeyManager getencriptwithPrikey:prikey andPubkey:pubkey adnMessage:data[data]];


   } WithFailBlock:^(id  _Nonnull data) {

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
