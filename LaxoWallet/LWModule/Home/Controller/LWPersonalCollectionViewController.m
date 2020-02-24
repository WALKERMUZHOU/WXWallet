//
//  LWPersonalCollectionViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalCollectionViewController.h"
#import "LBXScanNative.h"

@interface LWPersonalCollectionViewController ()

@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel     *qrCodeLabel;
@property (nonatomic, strong) NSString  *codeStr;

@end

@implementation LWPersonalCollectionViewController

+ (instancetype)shareInstanceWithCodeStr:(NSString *)codeStr{
    LWPersonalCollectionViewController *personVC = [[LWPersonalCollectionViewController alloc] init];
    personVC.codeStr = codeStr;
    return personVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNaviBar];
    [self creatuUI];
}

- (void)createNaviBar{
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    [self.view addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, 44)];
    titleLabel.text = @"收款";
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

- (void)creatuUI{
    self.qrCodeImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.qrCodeImageView];
    
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(240);
        make.width.height.equalTo(@(kScreenWidth - 100*2));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.qrCodeLabel = [[UILabel alloc] init];
    [self.qrCodeLabel setFont:kSemBoldFont(14)];
    [self.qrCodeLabel setTextColor:lwColorBlack];
    [self.view addSubview:self.qrCodeLabel];
    [self.qrCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeImageView.mas_bottom).offset(18);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:kSemBoldFont(14)];
    [titleLabel setTextColor:lwColorBlack];
    titleLabel.text = @"此地址仅用于BSV收款";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeLabel.mas_bottom).offset(70);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIImage *qrImage = [LBXScanNative createQRWithString:self.codeStr QRSize:CGSizeMake(400, 400)];
    [self.qrCodeImageView setImage:qrImage];
    [self.qrCodeLabel setText:self.codeStr];

}

#pragma mark method
- (void)backClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
