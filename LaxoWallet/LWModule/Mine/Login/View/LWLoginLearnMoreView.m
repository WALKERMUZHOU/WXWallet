//
//  LWLoginLearnMoreView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginLearnMoreView.h"

@interface LWLoginLearnMoreView ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation LWLoginLearnMoreView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.closeBtn.layer.borderColor = lwColorGrayD8.CGColor;
}
- (IBAction)closeClick:(UIButton *)sender {
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
