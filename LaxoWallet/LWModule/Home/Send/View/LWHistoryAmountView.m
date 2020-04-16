//
//  LWHistoryAmountView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHistoryAmountView.h"

@interface LWHistoryAmountView ()
@property (weak, nonatomic) IBOutlet UILabel *bitLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@end

@implementation LWHistoryAmountView

- (void)setAmountViewWithBitAmount:(NSString *)bit{
    self.bitLabel.text = [NSString stringWithFormat:@"%@BSV",bit];
    self.currencyLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:bit.doubleValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
