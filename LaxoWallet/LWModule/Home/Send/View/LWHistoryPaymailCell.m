//
//  LWHistoryPaymailCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHistoryPaymailCell.h"

@interface LWHistoryPaymailCell ()
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymailLabel;

@end

@implementation LWHistoryPaymailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(LWHistoryPaymailModel *)model{
    _model = model;
    
    self.iconLabel.text = [_model.paymail substringToIndex:1];
    self.paymailLabel.text = _model.paymail;
    if (_model.isSelect) {
        self.iconLabel.backgroundColor = lwColorNormal;
        self.paymailLabel.font = kBoldFont(14);
    }else{
        self.iconLabel.backgroundColor = lwColorGrayD8;
        self.paymailLabel.font = kFont(14);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
