//
//  LWPageControl.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPageControl.h"

@implementation LWPageControl

- (void)setCurrentPage:(NSInteger)page {

    [super setCurrentPage:page];

    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {

        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];

        CGSize size;

        size.height = 10;

        size.width = 10;

        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,

        size.width,size.height)];

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
