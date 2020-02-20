//
//  LWNewMultiPartyWalletViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWNewMultiPartyWalletViewController.h"
#import "LWInputTextField.h"
#import "LWInputTextView.h"
#import "LWSelectButton.h"
#import "LWCommonBottomBtn.h"

@interface LWNewMultiPartyWalletViewController ()

@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) LWInputTextField  *partyNumTF;
@property (nonatomic, strong) LWInputTextField  *KeyNumTF;
@property (nonatomic, strong) LWSelectButton    *selectBtn;

@property (nonatomic, strong) LWInputTextField  *walletNameTF;

@property (nonatomic, strong) LWInputTextView   *emailTV;


@end

@implementation LWNewMultiPartyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)createUI{
    self.title = @"多方控制钱包";
    CGFloat preLeft = 12;
    CGFloat normalWidth = kScreenWidth - preLeft*2;
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds ];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    self.scrollView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.scrollView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = lwColorLabel1;
    titleLabel.font = kSemBoldFont(16);
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"you are creating a multiparty wallet that requires n out of m(m>n) members to successfully sign a transaction";
    [self.scrollView addSubview:titleLabel];
    
    self.partyNumTF = [[LWInputTextField alloc] initWithFrame:CGRectMake(preLeft, 0, kScreenWidth- preLeft*2, 42.5) andType:LWInputTextFieldTypeNormal];
    self.partyNumTF.lwTextField.placeholder = @"number of participants required to sign(n)";
    self.partyNumTF.lwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.partyNumTF];
    
    self.KeyNumTF = [[LWInputTextField alloc] initWithFrame:CGRectMake(preLeft, 0, kScreenWidth- preLeft*2, 42.5) andType:LWInputTextFieldTypeNormal];
    self.KeyNumTF.lwTextField.placeholder = @"number of total key shares(m)";
    self.KeyNumTF.lwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.KeyNumTF];
    
    UILabel *surelabel = [[UILabel alloc]init];
    surelabel.font = kFont(14);
    surelabel.textColor = lwColorLabel1;
    surelabel.text = @"Laxo as a key part holder(recommended)";
    [self.scrollView addSubview:surelabel];
    
    self.selectBtn = [[LWSelectButton alloc] init];
    self.selectBtn.selected = NO;
    [self.scrollView addSubview:self.selectBtn];
    
    self.walletNameTF = [[LWInputTextField alloc] initWithFrame:CGRectMake(preLeft, 0, kScreenWidth- preLeft*2, 42.5) andType:LWInputTextFieldTypeleftSelect];
    self.walletNameTF.lwTextField.placeholder = @"Wallet Name:";
    [self.scrollView addSubview:self.walletNameTF];
    
    self.emailTV = [[LWInputTextView alloc] initWithFrame:CGRectMake(preLeft, 0, kScreenWidth - preLeft*2, 165)];
    [self.scrollView addSubview:self.emailTV];
    
    LWCommonBottomBtn *bottomBtn = [[LWCommonBottomBtn alloc]init];
    [bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setTitle:@"Invite" forState:UIControlStateNormal];
    bottomBtn.selected = YES;
    [self.scrollView addSubview:bottomBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(12);
        make.width.equalTo(@(normalWidth));
        make.top.equalTo(self.scrollView.mas_top).offset(15);
    }];
    
    [self.partyNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(12);
        make.right.equalTo(self.scrollView.mas_right).offset(-12);
        make.top.equalTo(titleLabel.mas_bottom).offset(13);
        make.height.equalTo(@(42.5));
        make.width.equalTo(@(normalWidth));
    }];
    
    [self.KeyNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(12);
        make.right.equalTo(self.scrollView.mas_right).offset(-12);
        make.top.equalTo(self.partyNumTF.mas_bottom).offset(13);
        make.height.equalTo(@(42.5));
        make.width.equalTo(@(normalWidth));
    }];
    
    [surelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(12);
        make.top.equalTo(self.KeyNumTF.mas_bottom).offset(7);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(surelabel.mas_right).offset(30);
        make.centerY.equalTo(surelabel.mas_centerY);
        make.width.height.equalTo(@(20));
    }];
    
    [self.walletNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(12);
        make.right.equalTo(self.scrollView.mas_right).offset(-12);
        make.top.equalTo(surelabel.mas_bottom).offset(38.5);
        make.height.equalTo(@(42.5));
        make.width.equalTo(@(normalWidth));
    }];
    
    [self.emailTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(12);
        make.right.equalTo(self.scrollView.mas_right).offset(-12);
        make.top.equalTo(self.walletNameTF.mas_bottom).offset(18);
        make.width.equalTo(@(normalWidth));
        make.height.equalTo(@(165));
    }];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.scrollView.mas_left).offset(12);
       make.right.equalTo(self.scrollView.mas_right).offset(-12);
       make.top.equalTo(self.emailTV.mas_bottom).offset(38.5);
       make.height.equalTo(@(42.5));
       make.width.equalTo(@(normalWidth));
    }];
    
    if (717 > KScreenHeightBar) {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, 750);
        self.scrollView.scrollEnabled = YES;
        self.scrollView.alwaysBounceVertical = YES;
    }
}

- (void)bottomClick:(UIButton *)sender{

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
