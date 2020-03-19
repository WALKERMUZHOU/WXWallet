//
//  LWPersonalListTableViewCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalListTableViewCell.h"
#import "LWTimeTool.h"

@interface LWPersonalListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;

@end


@implementation LWPersonalListTableViewCell


- (void)setModel:(LWMessageModel *)model{
    _model = model;
    
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.createtime.integerValue/1000];
    NSString *time = [dateStringFormatter stringFromDate:date];

    self.timeLabel.text = [LWTimeTool subStingOfYMD:time abbreviations:YES EnglishShortNameForDate:NO];;
    
    if (_model.status == 2){
        if (_model.type == 1) {//转出
            self.bitCountLabel.text = [NSString stringWithFormat:@"-%@",@(_model.value/1e8)];
            self.typeLabel.text = @"Send";
            self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];

        }else{
            self.bitCountLabel.text = [NSString stringWithFormat:@"+%@",@(_model.value/1e8)];
            self.typeLabel.text = @"Receive";
            self.iconImageView.image = [UIImage imageNamed:@"home_wallet_receive"];
        }
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
