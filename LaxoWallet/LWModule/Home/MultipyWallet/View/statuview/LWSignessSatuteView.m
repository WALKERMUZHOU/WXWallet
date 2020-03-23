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

- (void)setSignessSatuteViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel{
    self.walletModel = walletModel;
    self.messageModel = messageModel;

    LWSignStatueListView *listView = [[LWSignStatueListView alloc] initWithFrame:self.backView.bounds style:UITableViewStyleGrouped];
    [listView setSignessSatuteViewWithWalletModel:self.walletModel andMessageModel:self.messageModel];
    [self.backView addSubview:listView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
