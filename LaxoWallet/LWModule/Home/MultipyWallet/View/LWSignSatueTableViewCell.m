//
//  LWSignSatueTableViewCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSignSatueTableViewCell.h"

@interface LWSignSatueTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@end

@implementation LWSignSatueTableViewCell

- (void)setStauteModel:(LWSignStatueModel *)stauteModel{
    _stauteModel = stauteModel;
    
    if (_stauteModel.isOnLine) {
        self.iconImageView.image = [UIImage imageNamed:@"home_wallet_online"];
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"home_wallet_offline"];
    }
    
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",(long)_stauteModel.index];
    self.emailLabel.text = _stauteModel.email;
    
    if (_stauteModel.currentStatue == 1) {
        self.statueLabel.text = @"SIGNED";
        self.coverView.backgroundColor = lwColorNormal;
    }else{
        self.statueLabel.text = @"PENDING";
        self.coverView.backgroundColor = lwColorOrange;
    }
    
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
