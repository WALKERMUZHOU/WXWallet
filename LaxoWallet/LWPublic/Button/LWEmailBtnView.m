//
//  LWEmailBtnView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWEmailBtnView.h"

@interface LWEmailBtnView ()
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation LWEmailBtnView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor hex:@"#F6F6F6"];
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFont:kFont(16)];
    [self.titleLabel setTextColor:lwColorBlack];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"home_close_cor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.mas_right).offset(-5);
         make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@20);
     }];

}

- (void)setViewTitle:(NSString *)viewTitle{
    _viewTitle = viewTitle;
    self.titleLabel.text = _viewTitle;
}

- (void)backClick:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
    
}

- (CGFloat)getCurrentWidth{
    if (self.titleLabel.text.length>0) {
        CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(16)} context:nil].size;
        return titleSize.width + 45;
    }
    return 0.f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
