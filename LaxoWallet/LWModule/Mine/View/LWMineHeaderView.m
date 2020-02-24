//
//  LWMineHeaderView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineHeaderView.h"

@interface LWMineHeaderView ()

@property (nonatomic, strong) UILabel *nicNameLabel;
@property (nonatomic, strong) UILabel *propertyLabel;

@end

@implementation LWMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    CGFloat preleft = 22.5;
    self.backgroundColor = lwColorNormal;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:kFont(25)];
    [titleLabel setTextColor:lwColorBlack];
    titleLabel.text = @"昵称：";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight + 10);
        make.left.equalTo(self.mas_left).offset(preleft);
    }];
    
    self.nicNameLabel = [[UILabel alloc] init];
    [self.nicNameLabel setFont:kFont(25)];
    [self.nicNameLabel setTextColor:lwColorBlack];
    self.nicNameLabel.text = @"₿itcoin";
    [self addSubview:self.nicNameLabel];
    [self.nicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.left.equalTo(titleLabel.mas_right).offset(1);
    }];
    
    UILabel *proLabel = [[UILabel alloc] init];
    [proLabel setFont:kFont(20)];
    [proLabel setTextColor:lwColorBlack];
    proLabel.text = @"总资产：";
    [self addSubview:proLabel];
    [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(preleft);
    }];
    
    self.propertyLabel = [[UILabel alloc] init];
    [self.propertyLabel setFont:kFont(20)];
    [self.propertyLabel setTextColor:lwColorBlack];
    self.propertyLabel.text = @"¥10000";
    [self addSubview:self.propertyLabel];
    [self.propertyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(proLabel.mas_centerY);
        make.left.equalTo(proLabel.mas_right).offset(1);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"mine_head"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-28);
        make.width.height.equalTo(@60);
        make.top.equalTo(titleLabel.mas_top).offset(5);
    }];
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setButton setBackgroundImage:[UIImage imageNamed:@"mine_setting"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setButton];
    [setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_left).offset(-25);
        make.width.height.equalTo(@24);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    

}


- (void)buttonClick:(UIButton *)sender{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
