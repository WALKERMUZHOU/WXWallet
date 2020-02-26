//
//  LWMessageImageTitleButton.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageImageTitleButton.h"

@interface LWMessageImageTitleButton ()

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UILabel  *titleLabel;


@end

@implementation LWMessageImageTitleButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageButton.frame = CGRectMake(0, 0, 50, 50);
    [self.imageButton setBackgroundImage:[UIImage imageNamed:@"common_logo"] forState:UIControlStateNormal];
    [self.imageButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.imageButton.kcenterX = self.frame.size.width/2;
    [self addSubview:self.imageButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageButton.kbottom+10, self.frame.size.width, kFit(14))];
    [self.titleLabel setFont:kFont(kFit(10))];
    [self.titleLabel setTextColor:lwColorBlack];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

- (void)buttonClick{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setImage:(UIImage *)image andTitle:(NSString *)title{
    [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.titleLabel setText:title];
}

- (void)setIsDeleteBtn:(BOOL)isDeleteBtn{
    _isDeleteBtn = isDeleteBtn;
    if (_isDeleteBtn) {
        [self.imageButton setBackgroundImage:[UIImage imageNamed:@"message_delete"] forState:UIControlStateNormal];
        [self.titleLabel setText:@"删除成员"];
    }
}

- (void)setIsAddBtn:(BOOL)isAddBtn{
    _isAddBtn = isAddBtn;
    if (_isAddBtn) {
        [self.imageButton setBackgroundImage:[UIImage imageNamed:@"message_add"] forState:UIControlStateNormal];
        [self.titleLabel setText:@"添加成员"];
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
