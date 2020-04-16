//
//  LWSendAmountChangeView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/14.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWNumberOutputView.h"

@interface LWNumberOutputView()

@property (weak, nonatomic) IBOutlet UILabel *firstAmount;
@property (weak, nonatomic) IBOutlet UILabel *firstType;

@property (weak, nonatomic) IBOutlet UILabel *seconType;
@property (weak, nonatomic) IBOutlet UILabel *secondAmount;

@property (nonatomic, assign) BOOL isBSVTop;

@end

@implementation LWNumberOutputView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.isBSVTop = YES;
    self.seconType.text = [LWCurrencyTool getCurrentCurrencyEnglishCode];
}

- (IBAction)switchClick:(UIButton *)sender {
    self.isBSVTop = !self.isBSVTop;
    [self exchageType];
}

- (void)exchageType{
    NSString *topAmount = self.firstAmount.text;
    NSString *topType = self.firstType.text;
    
    self.firstType.text = self.seconType.text;
    self.firstAmount.text = self.secondAmount.text;
    self.seconType.text = topType;
    self.secondAmount.text = topAmount;
}

- (void)setTopAmount:(NSString *)amount{
    NSLog(@"input:%@",amount);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.firstAmount.text isEqualToString:@"0"]) {
            if ([amount isEqualToString:@"0"]) {
                return;
            }
        }
        
        if ([amount isEqualToString:@"."] && [self.firstAmount.text containsString:@"."]) return;
        
        if([amount isEqualToString:@"<"]){
            if (self.firstAmount.text.length > 1) {
                self.firstAmount.text = [self.firstAmount.text stringByReplacingCharactersInRange:NSMakeRange(self.firstAmount.text.length-1, 1) withString:@""];
            }else{
                self.firstAmount.text = @"0";
            }
        }else{
            if ([self.firstAmount.text isEqualToString:@"0"] && [amount isEqualToString:@"."]  ) {
                self.firstAmount.text = [self.firstAmount.text stringByAppendingString:amount];
            }else if ([self.firstAmount.text isEqualToString:@"0"]){
                self.firstAmount.text = amount;
            }else{
                self.firstAmount.text = [self.firstAmount.text stringByAppendingString:amount];
            }
        }
        NSLog(@"outpir:%@",self.firstAmount.text);

        [self reSetSecondAmountStr];
    });
}

- (void)setBitAmount:(NSString *)amount{
    if (self.isBSVTop) {
        self.firstAmount.text = amount;
        self.secondAmount.text = [LWCurrencyTool getCurrentCurrencyWithBitCount:self.firstAmount.text.doubleValue];
        if (self.block) {
            self.block(self.firstAmount.text,self.secondAmount.text);
        }
    }else{
        self.secondAmount.text = amount;
        self.firstAmount.text = [LWCurrencyTool getCurrentCurrencyWithBitCount:self.secondAmount.text.doubleValue];
        if (self.block) {
            self.block(self.firstAmount.text,self.secondAmount.text);
        }
    }
}

- (void)reSetSecondAmountStr{
    if (self.isBSVTop) {
        self.secondAmount.text = [LWCurrencyTool getCurrentCurrencyWithBitCount:self.firstAmount.text.doubleValue];
        if (self.block) {
            self.block(self.firstAmount.text,self.secondAmount.text);
        }
    }else{
        self.secondAmount.text = [LWCurrencyTool getBitCountWithCurrency:self.firstAmount.text.doubleValue];
        if (self.block) {
            self.block(self.secondAmount.text,self.firstAmount.text);
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
