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
            
            self.typeLabel.text = [NSString stringWithFormat:@"BSV %ld/%ld",(long)_model.threshold,(long)_model.share];
            self.nameLabel.text = _model.name;
            if(_model.status == 0){//状态0-创建中，1-已创建，2-已删除
                self.bitCountLabel.hidden = YES;
                self.currentPriceLabel.hidden = YES;
                [self.personalBitCountLabel setTextColor:[UIColor redColor]];
                self.personalBitCountLabel.hidden= NO;
                self.personalBitCountLabel.text = [NSString stringWithFormat:@"%ld方待加入",(long)(_model.share - _model.join)];
            }else if (model.status == 1){
                self.bitCountLabel.hidden = NO;
                self.currentPriceLabel.hidden = NO;
                self.personalBitCountLabel.hidden = YES;
                self.bitCountLabel.text = [NSString stringWithFormat:@"%@",@(_model.personalBitCount)];
            }else{
                
            }
        }
            
            break;
        default:
            break;
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
