//
//  LWLoginSecondStepView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginSecondStepView.h"

@implementation LWLoginSecondStepView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)noSetPwdClick:(UIButton *)sender {
    [LogicHandle showTabbarVC];
}

- (IBAction)setPswClick:(UIButton *)sender {
    [LogicHandle showTabbarVC];
}
@end
