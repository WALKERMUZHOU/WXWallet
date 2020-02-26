//
//  LWMessageDeleteTableViewCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageDeleteTableViewCell.h"

@interface LWMessageDeleteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation LWMessageDeleteTableViewCell

- (IBAction)selectClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.cellSelectBlock) {
        self.cellSelectBlock(sender.isSelected);
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
