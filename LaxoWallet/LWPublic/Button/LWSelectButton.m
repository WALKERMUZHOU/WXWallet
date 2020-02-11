//
//  LWSelectButton.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSelectButton.h"

@implementation LWSelectButton

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"home_checkbox-fill"] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageNamed:@"home-checkbox"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(selfClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)selfClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
