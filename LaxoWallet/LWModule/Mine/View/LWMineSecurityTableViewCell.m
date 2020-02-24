//
//  LWMineSecurityTableViewCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineSecurityTableViewCell.h"

@interface LWMineSecurityTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation LWMineSecurityTableViewCell

- (void)setInfoDic:(NSDictionary *)infoDic{
    self.titleDesLabel.text = [infoDic objectForKey:@"title"];
    self.contentLabel.text = [infoDic objectForKey:@"type"];

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
