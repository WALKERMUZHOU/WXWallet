//
//  LWRecoveryView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWRecoveryView.h"
#import "CZCategoryScrollView.h"
#import "LWRecoveryFileView.h"
#import "LWRecoveryTrustholdsView.h"

@interface LWRecoveryView()<CZCategoryScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CZCategoryScrollView  *categoryScrollView;
@property (nonatomic, strong) LWRecoveryFileView  *fileView;
@property (nonatomic, strong) LWRecoveryTrustholdsView  *trustholdsView;

@property (nonatomic, strong) UIButton  *packageBtn;
@property (nonatomic, strong) UIButton  *trustholdsBtn;
@property (nonatomic, strong) UIView    *bottomLine;

@end

@implementation LWRecoveryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{

    UIImageView *imageView = [[UIImageView alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageView setImage:[UIImage imageNamed:@"common_logo"]];
    });
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(60);
        make.width.height.equalTo(@(60));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"恢复钱包";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.packageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.packageBtn setTitle:@"通过备份恢复钱包" forState:UIControlStateNormal];
    [self.packageBtn setTitleColor:lwColorBlack forState:UIControlStateNormal];
    [self.packageBtn setTitleColor:lwColorNormal forState:UIControlStateSelected];
    [self.packageBtn addTarget:self action:@selector(packageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.packageBtn];
    self.packageBtn.selected = YES;
    [self.packageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth/4);
    }];

    self.trustholdsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.trustholdsBtn setTitle:@"通过备份恢复钱包" forState:UIControlStateNormal];
    [self.trustholdsBtn setTitleColor:lwColorBlack forState:UIControlStateNormal];
    [self.trustholdsBtn setTitleColor:lwColorNormal forState:UIControlStateSelected];
    [self.trustholdsBtn addTarget:self action:@selector(trustholdsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.trustholdsBtn];
    [self.trustholdsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right).offset(-kScreenWidth/4);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
    }];

    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(30, 240, kScreenWidth/2 - 60, 2)];
    self.bottomLine.backgroundColor = lwColorNormal;
    [self addSubview:self.bottomLine];

    self.fileView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([LWRecoveryFileView class]) owner:nil options:nil].lastObject;
    [self addSubview:self.fileView];
    self.fileView.frame = CGRectMake(0, self.bottomLine.kbottom, kScreenWidth, kScreenHeight - self.bottomLine.kbottom);
    
//
    self.trustholdsView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([LWRecoveryTrustholdsView class]) owner:nil options:nil].lastObject;
    [self addSubview:self.trustholdsView];
    self.trustholdsView.frame = CGRectMake(0, self.bottomLine.kbottom, kScreenWidth, kScreenHeight - self.bottomLine.kbottom);
    self.trustholdsView.hidden = YES;


//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        
//        self.categoryScrollView = [[CZCategoryScrollView alloc]initWithFrame:CGRectMake(0.f, 200, kScreenWidth, 44)];
//         self.categoryScrollView.backgroundColor = UIColorFromRGB(kColorBackgroundWhite);
//         self.categoryScrollView.delegate = self;
//         self.categoryScrollView.maxTitleNumberPerPage = 2;
//         self.categoryScrollView.autoCalculateTitleSize = NO;
//         self.categoryScrollView.showBottomLine = YES;
//         self.categoryScrollView.bottomLineColor = [UIColor clearColor];
//         self.categoryScrollView.showUpLine = YES;
//         self.categoryScrollView.titleColor = UIColorFromRGB(kColorStringBlack);
//         self.categoryScrollView.titlesSpace = 50;
//         CZCategoryInnerLine *bottomLine = [[CZCategoryInnerLine alloc]init];
//         bottomLine.width = 1.5;
//         bottomLine.backgroundColor = lwColorNormal;
//         bottomLine.halfLengthMoreThanTitle =0;
//         [self.categoryScrollView setSelectedLine:bottomLine];
//         self.categoryScrollView.showUpLine = NO;
//         self.categoryScrollView.font = kFont(14);
//         self.categoryScrollView.preLeftWidth = 20;
//         self.categoryScrollView.kcenterX = kScreenWidth/2;
//         [self addSubview:self.categoryScrollView];
//         self.categoryScrollView.scrollView.scrollEnabled = NO;
//         self.categoryScrollView.titleArray = @[@"通过备份恢复钱包",@"通过Trustholds服务恢复"];
//         self.categoryScrollView.followScrollView = nil;
//        
//
//    });

    
}

- (void)packageBtnClick:(UIButton *)sender{
    if (sender.isSelected == YES) {
        return;
    }
    self.packageBtn.selected = YES;
    self.trustholdsBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.kright = kScreenWidth/2 - 30;
        self.fileView.hidden = NO;
        self.trustholdsView.hidden = YES;
    }];
    
}

-(void)trustholdsBtnClick:(UIButton *)sender{
    if (sender.isSelected == YES) {
        return;
    }
    self.packageBtn.selected = NO;
    self.trustholdsBtn.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.kleft = kScreenWidth/2 + 30;
        self.fileView.hidden = YES;
        self.trustholdsView.hidden = NO;
    }];
}


#pragma mark - czcategorydelegate
- (void)categoryScrollView:(CZCategoryScrollView *)scrollView clickedIndex:(NSInteger)index{
    if (index == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.fileView.hidden = NO;
            self.trustholdsView.hidden = YES;
        }];
    }else{

        [UIView animateWithDuration:0.3 animations:^{
            self.fileView.hidden = YES;
            self.trustholdsView.hidden = NO;
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
