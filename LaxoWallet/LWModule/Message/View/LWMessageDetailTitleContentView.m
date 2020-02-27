//
//  LWMessageDetailTitleContentView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageDetailTitleContentView.h"

@interface LWMessageDetailTitleContentView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *tipButton;
@end

@implementation LWMessageDetailTitleContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 0, 90, frame.size.height)];
        [self.titleLabel setFont:kFont(17.5)];
        [self.titleLabel setTextColor:lwColorGray7A];
        [self addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentLabel setFont:kFont(17.5)];
        [self.contentLabel setTextColor:lwColorBlack];
        self.contentLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-27);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tipButton setImage:[UIImage imageNamed:@"message_link"] forState:UIControlStateNormal];
        [self.tipButton addTarget:self action:@selector(tipClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tipButton];
        [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentLabel.mas_left);
            make.width.height.equalTo(@17.5);
            make.centerY.equalTo(self.mas_centerY);
        }];

    }
    return self;
}

- (void)setTitle:(NSString *)title andContent:(NSString *)content andIsShowTip:(BOOL)isShow{
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.tipButton.hidden = !isShow;
    if ([content containsString:@"***"]) {
        self.tipButton.hidden = NO;
    }else{
        self.tipButton.hidden = YES;
    }
}

- (void)tipClick:(UIButton *)sender{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
