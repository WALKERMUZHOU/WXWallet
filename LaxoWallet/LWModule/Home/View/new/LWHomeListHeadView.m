//
//  LWHomeListHeadView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListHeadView.h"

@interface LWHomeListHeadView ()

@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *multipyBtn;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeButton;

@end


@implementation LWHomeListHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.personalBtn.selected = YES;
    self.multipyBtn.selected = NO;
    [self.multipyBtn.titleLabel setFont:kFont(16)];
}


- (IBAction)personBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    self.multipyBtn.selected = NO;
    [self.multipyBtn.titleLabel setFont:kFont(16)];
    [self.personalBtn.titleLabel setFont:kBoldFont(16)];

    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(0, 0, 115, 40);
    }];
}

- (IBAction)multipyBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
          return;
      }
    sender.selected = YES;
    self.personalBtn.selected = NO;
    [self.multipyBtn.titleLabel setFont:kBoldFont(16)];
    [self.personalBtn.titleLabel setFont:kFont(16)];
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(115, 0, 115, 40);
    }];
}

- (IBAction)eyeClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.priceLabel.text = @"***";
    }else{
        self.priceLabel.text = @"0.00";
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
