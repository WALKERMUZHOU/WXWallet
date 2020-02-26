//
//  LWMessageTableViewCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageTableViewCell.h"

@interface LWMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *needLabel;

@property (weak, nonatomic) IBOutlet UIButton *joinButton;


@end

@implementation LWMessageTableViewCell

- (void)setModel:(LWHomeWalletModel *)model{
    _model = model;
    self.iconImageView.backgroundColor = _model.iconColor;
    if (_model.type == 1) {
        self.iconLabel.text = @"个";
        self.nameLabel.text = @"个人钱包";
    }else{
        self.iconLabel.text = [_model.name substringToIndex:1];
        self.nameLabel.text = _model.name;
    }
    
    if (_model.status == 0) {
        self.iconImageView.image = [UIImage imageNamed:@"messge_addWallet"];
        self.iconLabel.hidden = YES;
    }else{
        self.iconImageView.image = nil;
        self.iconLabel.hidden = NO;
    }
    
    self.joinButton.hidden = _model.join == 0 ? NO : YES;
    if (_model.status == 0) {
        self.needLabel.hidden = NO;
        self.needLabel.text = @"创建中？？？";
    }else{
        self.needLabel.hidden = YES;
    }
    
//    if(_model.join == 0){
//        self.joinButton.hidden = NO;
//    }else{
//        self.joinButton.hidden = YES;
//    }
    
    
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
