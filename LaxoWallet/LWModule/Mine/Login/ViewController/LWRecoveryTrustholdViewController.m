//
//  LWRecoveryTrustholdViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/12.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWRecoveryTrustholdViewController.h"
#import "LWInputTextField.h"
#import "LWCommonBottomBtn.h"
#import "LWLoginCoordinator.h"
#import "PubkeyManager.h"
#import "LWFaceBindViewController.h"

@interface LWRecoveryTrustholdViewController ()

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) LWInputTextField   *textField;
@end

@implementation LWRecoveryTrustholdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI{
    self.title = @"恢复钱包";
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = lwColorBlack1;
    [self.view addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = kSemBoldFont(16);
    self.titleLabel.text = @"请输入来自trusthold的验证码恢复钱包";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(79 + kNavigationBarHeight);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    
    CGFloat preLeft = 13.f;
    self.textField = [[LWInputTextField alloc] initWithFrame:CGRectMake(preLeft, 0, kScreenWidth- preLeft*2, 50) andType:LWInputTextFieldTypeNormal];
    self.textField.lwTextField.placeholder = @"来自maxthon的邮箱验证码";
    self.textField.lwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.textField];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.titleLabel.mas_bottom).offset(75);
       make.left.equalTo(self.view.mas_left).offset(17);
       make.right.equalTo(self.view.mas_right).offset(-17);
        make.height.equalTo(@50);
    }];
    
    LWCommonBottomBtn *bottomBtn = [[LWCommonBottomBtn alloc]init];
    [bottomBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setTitle:@"恢复" forState:UIControlStateNormal];
    bottomBtn.selected = YES;
    [self.view addSubview:bottomBtn];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.textField.mas_bottom).offset(110);
       make.left.equalTo(self.view.mas_left).offset(12);
       make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@50);
    }];
    
}

#pragma mark - method
- (void)buttonClick{
    
    if(!self.textField.lwTextField || self.textField.lwTextField.text.length == 0 ){
        [WMHUDUntil showMessageToWindow:@"请输入验证码"];
        return;
    }
    
    NSArray *array = [[LWTrusteeManager shareInstance] getTrusteeArray];
    NSMutableArray *seedDataArray = [NSMutableArray array];
    NSString *msgCode = self.textField.lwTextField.text;
    [SVProgressHUD show];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        for (NSInteger i = 0; i<array.count; i++) {
            LWTrusteeModel *model = [array objectAtIndex:i];

            [LWLoginCoordinator verifyRecoveryEmailCodeWithCode:msgCode andModel:model WithSuccessBlock:^(id  _Nonnull data) {
                NSLog(@"data%@",[data objectForKey:@"data"]);
                [seedDataArray addObject:[data objectForKey:@"data"]];
                if (i == array.count - 1) {//最后一次 根据data 计算seed
                    [self calculateSeed:seedDataArray];
                }
                dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面

            } WithFailBlock:^(id  _Nonnull data) {
                dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
            }];
            dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        }
    });
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
}

- (void)getRecoverData:(NSArray *)array{
    [PubkeyManager getRecoverData:array WithSuccessBlock:^(id  _Nonnull data) {
        LWUserModel *model = [[LWUserManager shareInstance] getUserModel];
        model.jiZhuCi = data;
        [[LWUserManager shareInstance] setUser:model];
        LWFaceBindViewController *lwfaceVC = [[LWFaceBindViewController alloc]init];
        [self.navigationController pushViewController:lwfaceVC animated:YES];
        return ;
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
