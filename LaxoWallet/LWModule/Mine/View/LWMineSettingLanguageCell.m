//
//  LWMineSettingLanguageCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineSettingLanguageCell.h"

@interface LWMineSettingLanguageCell()
@property (weak, nonatomic) IBOutlet UILabel *titleDesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;

@end

@implementation LWMineSettingLanguageCell

- (void)setModel:(LWCurrencyModel *)model{
    _model = model;
    self.titleDesLabel.text = _model.title;
    if (_model.statue == 2) {
        self.rightImgV.hidden = NO;
    }else{
        self.rightImgV.hidden = YES;
    }
}


//- (void)setIsCellSelect:(BOOL)isCellSelect{
//    _isCellSelect = isCellSelect;
//    if(_isCellSelect){
//        [self.titleDesLabel setTextColor:lwColorNormal];
//        self.rightImgV.hidden = NO;
//    }else{
//        [self.titleDesLabel setTextColor:lwColorBlackLight];
//        self.rightImgV.hidden = YES;
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        [self.titleDesLabel setTextColor:lwColorNormal];
//        self.rightImgV.hidden = NO;
//    }else{
//        [self.titleDesLabel setTextColor:lwColorBlackLight];
//        self.rightImgV.hidden = YES;
//
//    }
//    // Configure the view for the selected state
//}

@end
