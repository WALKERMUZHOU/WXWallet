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
#import "QQLBXScanViewController.h"
#import "LBXPermission.h"
#import "LWFaceBindViewController.h"

#import "BFCryptor.h"

@interface LWRocoveryViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
    [LWPublicManager getInitData];
    
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
        [self qrcodeRecover];
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

#pragma mark - recoverMethod
- (void)qrcodeRecover{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto:(BOOL)allowsEditing{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //部分机型有问题
    picker.allowsEditing = allowsEditing;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [LBXZBarWrapper recognizeImage:image block:^(NSArray<LBXZbarResult *> *result) {
        LBXZbarResult *firstObj = result[0];
        NSString *scanedStr = firstObj.strScanned;
        [self recoverWithScanedStr:scanedStr];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)recoverWithScanedStr:(NSString *)scanStr{
    [SVProgressHUD show];

    NSString *jizhuci = [LWEncryptTool decryptwithTheKey:[[[LWUserManager shareInstance] getUserModel].secret md5String]  message:scanStr andHex:0];
    [[LWUserManager shareInstance] setJiZhuCi:jizhuci];
    [self jumpToFaceBindVC];
    
//    [PubkeyManager decrptWithSecret:[[[LWUserManager shareInstance] getUserModel].secret md5String] ansMessage:scanStr SuccessBlock:^(id  _Nonnull data) {
//        [SVProgressHUD dismiss];
//        if(data && [data isKindOfClass:[NSString class]]){
//            [[LWUserManager shareInstance] setJiZhuCi:data];
//            [self jumpToFaceBindVC];
//        }
//    } WithFailBlock:^(id  _Nonnull data) {
//
//    }];
}

- (void)jumpToFaceBindVC{
    LWFaceBindViewController *lwfaceVC = [[LWFaceBindViewController alloc]init];
    [self.navigationController pushViewController:lwfaceVC animated:YES];
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
