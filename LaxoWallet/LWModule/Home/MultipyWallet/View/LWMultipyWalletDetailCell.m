//
//  LWMultipyWalletDetailCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyWalletDetailCell.h"

@interface LWMultipyWalletDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;

@property (weak, nonatomic) IBOutlet UIView *statueBackView;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueDescribeLabel;

@end

@implementation LWMultipyWalletDetailCell

- (void)setModel:(LWMessageModel *)model{
    _model = model;
    
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.createtime.integerValue/1000];
    NSString *time = [dateStringFormatter stringFromDate:date];

    self.timeLabel.text = [LWTimeTool subStingOfYMD:time abbreviations:YES EnglishShortNameForDate:NO];;
    NSString *biCountStr = [LWNumberTool formatSSSFloat:_model.value/1e8];
    if (_model.status == 2){
        if (_model.type == 2) {//转出
            self.bitCountLabel.text = [NSString stringWithFormat:@"-%@",biCountStr];
            self.typeLabel.text = @"Sent";
            self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];
            self.statueLabel.text = @"Success";
            self.statueBackView.backgroundColor = lwColorNormal;
        }
    }else if(_model.status == 1){//未完成
        self.iconImageView.image = [UIImage imageNamed:@"home_wallet_waiting"];

    }else{
        self.typeLabel.text = @"Cancle";
        self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];
    }
    self.bitCountLabel.text = [NSString stringWithFormat:@"-%@",biCountStr];

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
