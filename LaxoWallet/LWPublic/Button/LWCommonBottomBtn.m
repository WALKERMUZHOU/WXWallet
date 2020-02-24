//
//  LWCommonBottomBtn.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWCommonBottomBtn.h"
#import "UIButton+BackgroundColor.h"

@implementation LWCommonBottomBtn

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self setBackgroundColor:lwColorNormal forState:UIControlStateSelected];
    [self setBackgroundColor:lwColorGrayC1 forState:UIControlStateNormal];
    [self.titleLabel setFont:kMediumFont(20)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
