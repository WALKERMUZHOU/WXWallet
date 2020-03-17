//
//  LWLoginStepEightView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepEightView.h"

@implementation LWLoginStepEightView
- (IBAction)scanClick:(UIButton *)sender {
    if (self.block) {
        self.block(1);
    }
}

- (IBAction)uploadClick:(UIButton *)sender {
    if (self.block) {
        self.block(2);
    }
}

- (IBAction)thrustClick:(UIButton *)sender {
    if (self.block) {
        self.block(3);
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
