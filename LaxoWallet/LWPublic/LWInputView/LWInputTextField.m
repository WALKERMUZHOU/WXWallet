//
//  LWInputTextField.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWInputTextField.h"
#import "PopoverView.h"

@interface LWInputTextField ()

@property (nonatomic, assign) LWInputTextFieldType textFieldType;

@end

@implementation LWInputTextField{
    
}

- (instancetype)initWithFrame:(CGRect)frame andType:(LWInputTextFieldType)textFieldType{
    self = [super initWithFrame:frame];
    if (self) {
        self.textFieldType = textFieldType;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 1;
    self.layer.borderColor = lwColorNormal.CGColor;
    
    self.lwTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-10, self.frame.size.height)];
    [self addSubview:self.lwTextField];
    
    if(self.textFieldType && self.textFieldType == 2){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, self.frame.size.height)];
        [button setTitle:@"BSV ▼" forState:UIControlStateNormal];
        [button.titleLabel setFont:kBoldFont(16)];
        [button setTitleColor:lwColorBlack forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIView *gapLine = [[UIView alloc] initWithFrame:CGRectMake(button.kright, 0, 1, self.frame.size.height)];
        gapLine.backgroundColor = lwColorNormal;
        [self addSubview:gapLine];
        
        self.lwTextField.frame = CGRectMake(gapLine.kright + 10, 0, self.frame.size.width - gapLine.kright, self.frame.size.height);
    }
}

- (void)buttonClick:(UIButton *)sender{
    return;
#warning 增加itc判断
     PopoverAction *action1 = [PopoverAction actionWithTitle:@"BSV" handler:^(PopoverAction *action) {
        }];
     PopoverAction *action2 = [PopoverAction actionWithTitle:@"BTC" handler:^(PopoverAction *action) {
        }];
        
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    // 在没有系统控件的情况下调用可以使用显示在指定的点坐标的方法弹出菜单控件.
    [popoverView showToView:sender withActions:@[action1, action2]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
