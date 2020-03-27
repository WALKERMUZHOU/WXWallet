//
//  LWLoginStepTwoView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepTwoView.h"
#import "LWEmailTool.h"

@interface LWLoginStepTwoView ()

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@end

@implementation LWLoginStepTwoView



- (IBAction)nextClick:(UIButton *)sender {
    
    if (self.emailTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"Please Input Email"];
        return;
    }
    
    if (![LWEmailTool isEmail:self.emailTF.text]) {
        [WMHUDUntil showMessageToWindow:@"Invalid Email"];
        return;
    }
    
    if (self.block) {
        self.block(self.emailTF.text);
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
