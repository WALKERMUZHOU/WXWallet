//
//  LWHomeAddWalletView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeAddWalletView.h"

@implementation LWHomeAddWalletView
- (void)awakeFromNib{
    [super awakeFromNib];
    [WMZDialogTool setView:self Radii:CGSizeMake(20,20) RoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight];
}

- (IBAction)personalClick:(UIButton *)sender {
    if (self.block) {
        self.block(1);
    }
}
- (IBAction)multipyClick:(UIButton *)sender {
    if (self.block) {
           self.block(2);
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
