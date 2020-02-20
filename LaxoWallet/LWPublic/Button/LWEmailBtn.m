//
//  LWEmailBtn.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWEmailBtn.h"

@implementation LWEmailBtn

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundColor:lwColorNormalLight];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setTitleColor:lwColorBlack forState:UIControlStateNormal];
        [self.titleLabel setFont:kSemBoldFont(15)];
    }
    return self;
}

- (CGFloat)getCurrentWidth{
    if (self.titleLabel.text.length>0) {
        CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kSemBoldFont(15)} context:nil].size;
        return titleSize.width + 7;
    }
    return 0.f;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
