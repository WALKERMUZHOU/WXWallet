//
//  LWLoginStepFiveViewOne.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/8.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepFiveViewOne.h"

@implementation LWLoginStepFiveViewOne
- (IBAction)nextClick:(UIButton *)sender {
    if (self.block) {
        self.block();
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
