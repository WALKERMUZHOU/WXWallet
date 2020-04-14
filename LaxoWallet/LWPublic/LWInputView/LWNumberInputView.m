//
//  LWNumberInputView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWNumberInputView.h"

@interface LWNumberInputView ()

@property (nonatomic, strong) NSString *outputStr;

@end


@implementation LWNumberInputView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.outputStr = @"0";
}


- (IBAction)oneClick:(UIButton *)sender {
    NSInteger senderCurrentIndex = sender.tag - 12000;
    self.outputStr = [self.outputStr stringByAppendingString:[NSString stringWithFormat:@"%ld",senderCurrentIndex]];
    if (self.block) {
        self.block(self.outputStr);
    }
}

- (IBAction)zeroClick:(UIButton *)sender {
    
    
    
}
- (IBAction)pointClick:(UIButton *)sender {
}
- (IBAction)deleteClick:(UIButton *)sender {
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
