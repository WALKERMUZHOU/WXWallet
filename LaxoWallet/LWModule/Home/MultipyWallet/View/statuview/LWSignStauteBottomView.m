//
//  LWSignStauteBottomView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSignStauteBottomView.h"

@interface LWSignStauteBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation LWSignStauteBottomView
- (IBAction)closeClick:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.closeBtn.layer.borderColor = lwColorGrayD8.CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
