//
//  LWSignessSatuteView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSignessSatuteView.h"
#import "LWSignStatueListView.h"


@interface LWSignessSatuteView ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *signCountLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) LWHomeWalletModel *walletModel;
@property (nonatomic, strong) LWMessageModel    *messageModel;

@end

@implementation LWSignessSatuteView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)setFrame:(CGRect)frame{
    frame.size.width=kScreenWidth;
    [super setFrame:frame];
}

- (void)setSignessSatuteViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel{
    self.walletModel = walletModel;
    self.messageModel = messageModel;
    
    self.timeLabel.text = [LWTimeTool EngLishMonthWithTimeStamp:messageModel.createtime abbreviations:YES EnglishShortNameForDate:NO];
     self.amountLabel.text = [LWNumberTool formatSSSFloat:self.messageModel.value/1e8];
     
     self.signCountLabel.text = [NSString stringWithFormat:@"%ld signees assigned",(long)self.messageModel.approve.count];
    
    LWSignStatueListView *listView = [[LWSignStatueListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.backView.kheight) style:UITableViewStyleGrouped];
    [listView setSignessSatuteViewWithWalletModel:self.walletModel andMessageModel:self.messageModel];
    [self.backView addSubview:listView];
    listView.block = ^{
        if (self.block) {
            self.block(0);
        }
    };
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
