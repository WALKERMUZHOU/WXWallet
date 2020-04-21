//
//  LWPCLoginTipView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/8.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPCLoginTipView.h"

@interface LWPCLoginTipView()
@property (weak, nonatomic) IBOutlet UILabel *loggedLabel;

@end

@implementation LWPCLoginTipView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.loggedLabel.text = kLocalizable(@"wallet_login_statue");
}

- (IBAction)buttinClick:(UIButton *)sender {
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
