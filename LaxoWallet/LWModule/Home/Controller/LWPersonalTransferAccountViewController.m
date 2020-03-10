//
//  LWPersonalTransferAccountViewController.m
//  LaxoWallet
//
//  Created by bitmesh on 2020/2/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalTransferAccountViewController.h"
#import "LWBottomLineInputTextField.h"
#import "LWCommonBottomBtn.h"
#import "UIView+LWPayView.h"
#import "LWTansactionTool.h"

@interface LWPersonalTransferAccountViewController ()

@property (nonatomic, strong) UILabel   *describLabel;
@property (nonatomic, strong) UILabel   *feeLabel;

@property (nonatomic, strong) LWBottomLineInputTextField *amountTF;
@property (nonatomic, strong) LWBottomLineInputTextField *payAddressTF;
@property (nonatomic, strong) LWBottomLineInputTextField *remarkTF;

@end

@implementation LWPersonalTransferAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账";
    [self createUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)createUI{
    [self createNaviBar];
    
    self.describLabel = [[UILabel alloc]init];
    self.describLabel.textColor = lwColorBlack;
    self.describLabel.font = kBoldFont(21);
    self.describLabel.numberOfLines = 0;
    self.describLabel.text = @"您正在发起一笔多方签名转账，至少需要除你之外的其他两方签名才能完成交易";
    [self.view addSubview:self.describLabel];
    [self.describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + 35);
    }];

    self.amountTF = [[LWBottomLineInputTextField alloc] initWithFrame:CGRectMake(0, 142+kNavigationBarHeight, kScreenWidth, 40) andType:LWBottomLineInputTextFieldTypeDescribe];
    self.amountTF.textField.placeholder = @"金额";
//    self.amountTF.descripStr = @"剩余120BSV";
    [self.view addSubview:self.amountTF];
    
    if (self.model) {
        NSString *describeStr = [NSString stringWithFormat:@"剩余%@BSV",@(_model.personalBitCount)];
        self.amountTF.descripStr = describeStr;
    }
    
    self.payAddressTF = [[LWBottomLineInputTextField alloc] initWithFrame:CGRectMake(0, self.amountTF.kbottom + 55, kScreenWidth, 40) andType:LWBottomLineInputTextFieldTypeButtons];
    self.payAddressTF.textField.placeholder = @"地址或PayMail ID";
    [self.view addSubview:self.payAddressTF];
    
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, self.payAddressTF.kbottom+2, 100, 20)];
    labelOne.text = @"费用";
    labelOne.textColor = lwColorBlackLight;
    labelOne.font = kBoldFont(14);
    [self.view addSubview:labelOne];
    
    self.feeLabel = [[UILabel alloc]init];
    self.feeLabel.textColor = lwColorBlack;
    self.feeLabel.font = kFont(16);
    self.feeLabel.text = @"35 sat/b";
    [self.view addSubview:self.feeLabel];
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.payAddressTF.mas_bottom).offset(2);
    }];

    self.remarkTF = [[LWBottomLineInputTextField alloc] initWithFrame:CGRectMake(0, self.payAddressTF.kbottom + 100, kScreenWidth, 40) andType:LWBottomLineInputTextFieldTypeNormal];
    self.remarkTF.textField.placeholder = @"备注(可选)";
    [self.view addSubview:self.remarkTF];
    
    LWCommonBottomBtn *bottomBtn = [[LWCommonBottomBtn alloc]init];
    [bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setTitle:@"下一步" forState:UIControlStateNormal];
    bottomBtn.selected = YES;
    [self.view addSubview:bottomBtn];
    bottomBtn.frame = CGRectMake(12, self.remarkTF.kbottom + 85, kScreenWidth - 24, 50);
}

- (void)createNaviBar{
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    [self.view addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, 44)];
    titleLabel.text = @"转账";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kFont(20);
    [naviView addSubview:titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
//    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    scanBtn.frame = CGRectMake(kScreenWidth-44, kStatusBarHeight, 44, 44);
//    [scanBtn setImage:[UIImage imageNamed:@"home_scan_black"] forState:UIControlStateNormal];
//    [scanBtn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
//    [naviView addSubview:scanBtn];
}

- (void)setModel:(LWHomeWalletModel *)model{
    _model = model;
    NSString *describeStr = [NSString stringWithFormat:@"剩余%@BSV",@(_model.personalBitCount)];
    [self.amountTF setDescripStr:describeStr];
}

- (void)backClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bottomClick:(UIButton *)sender{
        
    if (self.amountTF.textField.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"请输入金额"];
        return;
    }
    if (self.payAddressTF.textField.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"请输入地址"];
        return;
    }
    
    LWTansactionTool *trans = [[LWTansactionTool alloc] init];
    [trans startTransactionWithAmount:0.01 address:self.payAddressTF.textField.text note:self.remarkTF.textField.text andTotalModel:self.model];
    trans.transactionBlock = ^(BOOL success) {
        if (success) {
            [self requestPersonalWalletInfo];
            [self requestMulipyWalletInfo];
        }
    };
     
}


- (void)requestPersonalWalletInfo{
    NSDictionary *params = @{@"type":@1};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestIdWalletQueryPersonalWallet),
                                            @"wallet.query",
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)requestMulipyWalletInfo{
    NSDictionary *multipyparams = @{@"type":@2};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    });
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
