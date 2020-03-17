//
//  LWLoginStepSevenView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepSevenView.h"

@interface LWLoginStepSevenView ()

@property (weak, nonatomic) IBOutlet UITextField *codeTF;


@end


@implementation LWLoginStepSevenView

- (IBAction)verifyClick:(UIButton *)sender {
    if (self.codeTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"please input code"];
        return;
    }
    if (self.sevenBlock) {
        self.sevenBlock(self.codeTF.text);
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
