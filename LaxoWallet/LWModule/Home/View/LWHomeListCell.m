//
//  LWHomeListCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListCell.h"

@interface LWHomeListCell()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *personalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalBitCountLabel;
@end

@implementation LWHomeListCell



- (void)setModel:(LWHomeWalletModel *)model{
    _model = model;
    switch (model.type) {
        case 1:{
            self.typeLabel.hidden = YES;
            self.nameLabel.hidden = YES;
            self.bitCountLabel.hidden = YES;
            self.currentPriceLabel.hidden = YES;
            self.personalNameLabel.hidden = NO;
            self.personalBitCountLabel.hidden = NO;
            self.personalNameLabel.text = @"BSV";
            self.personalBitCountLabel.text = [NSString stringWithFormat:@"%@",@(_model.personalBitCount)];
        }
            
            break;
        case 2:{
            self.typeLabel.hidden = NO;
            self.nameLabel.hidden = NO;
            self.bitCountLabel.hidden = NO;
            self.currentPriceLabel.hidden = NO;
            self.personalNameLabel.hidden = YES;
            self.personalBitCountLabel.hidden = YES;
        }
            
            break;
        default:
            break;
    }
    self.typeLabel.text = model.name;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
