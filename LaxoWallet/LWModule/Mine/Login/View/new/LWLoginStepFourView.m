//
//  LWLoginStepFourView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepFourView.h"

@interface LWLoginStepFourView ()
@property (weak, nonatomic) IBOutlet UIButton *maxthonBtn;
@property (weak, nonatomic) IBOutlet UIButton *csgBtn;

@end

@implementation LWLoginStepFourView
- (IBAction)learnMoreClick:(UIButton *)sender {
    [WMHUDUntil showMessageToWindow:@"laernMore"];

}

- (IBAction)selectClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.tag == 10000) {
        self.csgBtn.selected = NO;
    }else{
        self.maxthonBtn.selected = NO;
    }
    
    
}

- (IBAction)nextClick:(UIButton *)sender {
    if (self.maxthonBtn.isSelected == NO && self.csgBtn.isSelected == NO) {
        
        [WMHUDUntil showMessageToWindow:@"selcet recover process"];
        return;
    }
    
    if (self.block) {
        
        if (self.maxthonBtn.isSelected) {
            self.block(@"Maxthon");
        }else{
            self.block(@"CoinStorageGuru");
        }
        
        
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
