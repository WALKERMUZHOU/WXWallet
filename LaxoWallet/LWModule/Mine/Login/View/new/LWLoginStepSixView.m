//
//  LWLoginStepSixView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepSixView.h"

@implementation LWLoginStepSixView
- (IBAction)recoverFormQRCode:(UIButton *)sender {
    if (self.sixBlock) {
        self.sixBlock(1);
    }
}


- (IBAction)recoverFormThrustholds:(UIButton *)sender {
    
    if (self.sixBlock) {
         self.sixBlock(2);
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
