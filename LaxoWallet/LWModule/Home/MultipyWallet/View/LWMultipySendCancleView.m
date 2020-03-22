//
//  LWMultipySendPendingView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipySendCancleView.h"

@interface LWMultipySendCancleView ()


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *txLinkLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *closeBtn;

@property (nonatomic, strong) LWMessageModel *messagemodel;

@end

@implementation LWMultipySendCancleView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.closeBtn.layer.borderColor = lwColorGrayD8.CGColor;
}


- (void)setSignedCancelViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel{
    self.messagemodel = messageModel;

    NSDictionary *userStatues = messageModel.user_status;
    NSArray *approve = [userStatues objectForKey:@"approve"];
            
    
    self.timeLabel.text = [LWTimeTool EngLishMonthWithTimeStamp:messageModel.createtime abbreviations:YES EnglishShortNameForDate:NO];
    self.amountLabel.text = [NSString stringWithFormat:@"-%@", [LWNumberTool formatSSSFloat:messageModel.value/1e8]];
    
//    LWutxoModel *model = messageModel.
    
    self.addressLabel.text = @"";
    self.createTimeLabel.text = [LWTimeTool dataFormateMMDDYYHHSS:messageModel.createtime];
    
  
    self.noteLabel.text = messageModel.note;
    self.txLinkLabel.text = [messageModel.txid stringByReplacingCharactersInRange:NSMakeRange(2, messageModel.txid.length - 6) withString:@"****"];
    self.amountDetailLabel.text = [NSString stringWithFormat:@"- %@ BSV  |  -%@",[LWNumberTool formatSSSFloat:messageModel.value/1e8],messageModel.priceDefine];
}

- (IBAction)closeClick:(UIButton *)sender {
    if (self.block) {
        self.block(0);
    }
}
- (IBAction)statueClick:(UIButton *)sender {
    if (self.block) {
        self.block(1);
    }
}

- (IBAction)copyClick:(UIButton *)sender {
    
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    [paste setString:self.messagemodel.txid];
    
}

@end
