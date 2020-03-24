//
//  LWPaymailTableViewCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPaymailTableViewCell.h"

@interface LWPaymailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *primaryBtn;

@end

@implementation LWPaymailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.primaryBtn.hidden = YES;
}

- (void)setModel:(LWPaymailModel *)model{
    _model = model;
    if (model.index == 0) {
        self.indexLabel.text = @"Primary Paymail handle";
        self.primaryBtn.hidden = YES;
    }else{
        self.indexLabel.text = [NSString stringWithFormat:@"NO.%ld Paymail handle",self.model.index+1];
        self.primaryBtn.hidden = NO;
    }
    self.userNameLabel.text = _model.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)primierClick:(UIButton *)sender {
    if (self.block) {
        self.block(self.model.paymailId);
    }
}

@end
