//
//  LWLoginStepThreeView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepThreeView.h"

@interface LWLoginStepThreeView ()
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end


@implementation LWLoginStepThreeView
- (IBAction)nextClick:(UIButton *)sender {
    
    if (self.codeTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"请输入验证码"];
        return;
    }
    
    if (self.block) {
         self.block(self.codeTF.text);
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
