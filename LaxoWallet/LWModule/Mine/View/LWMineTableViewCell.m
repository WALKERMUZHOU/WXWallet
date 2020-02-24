//
//  LWMineTableViewCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineTableViewCell.h"

@interface LWMineTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UILabel *contentdesLabel;
@end

@implementation LWMineTableViewCell

- (void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    self.titleDesLabel.text = [_infoDic objectForKey:@"title"];
    NSInteger type = [[_infoDic objectForKey:@"type"] integerValue];
    if (type == 1) {
        self.downLoadBtn.hidden = YES;
        self.rightArrow.hidden = NO;
        self.contentdesLabel.hidden = YES;
    }else if(type == 2){
        self.downLoadBtn.hidden = NO;
        self.rightArrow.hidden = YES;
        self.contentdesLabel.hidden = YES;
    }else if (type == 3){
        self.downLoadBtn.hidden = YES;
        self.rightArrow.hidden = NO;
        self.contentdesLabel.hidden = NO;
        self.contentdesLabel.text = [_infoDic objectForKey:@"content"];
    }
}
- (IBAction)downLoadClick:(UIButton *)sender {
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
