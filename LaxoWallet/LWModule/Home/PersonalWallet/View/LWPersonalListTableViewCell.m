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
    NSString *biCountStr = [LWNumberTool formatSSSFloat:_model.value/1e8];

    if (_model.status == 2){//完成
        if (_model.type == 2) {//转出
            self.bitCountLabel.text = [NSString stringWithFormat:@"-%@",biCountStr];
            self.typeLabel.text = @"Sent";
            self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];

        }else{
            self.bitCountLabel.text = [NSString stringWithFormat:@"+%@",biCountStr];
            self.typeLabel.text = @"Received";
            self.iconImageView.image = [UIImage imageNamed:@"home_wallet_receive"];
        }
    }
    
    if(_model.status == 3){
        self.bitCountLabel.text = [NSString stringWithFormat:@"-%@",biCountStr];
        self.iconImageView.image = [UIImage imageNamed:@"home_wallet_cancel_red"];
        self.typeLabel.text = @"Cancel";
        if (_model.type == 2) {//转出
             self.bitCountLabel.text = [NSString stringWithFormat:@"-%@",biCountStr];
         }else{
             self.bitCountLabel.text = [NSString stringWithFormat:@"+%@",biCountStr];
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
