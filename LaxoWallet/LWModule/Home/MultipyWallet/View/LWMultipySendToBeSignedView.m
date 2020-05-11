//
//  LWMultipySendToBeSignedView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipySendToBeSignedView.h"

@interface LWMultipySendToBeSignedView ()
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *satuedescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *signStatueBtn;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *txLinkLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong) LWMessageModel *messagemodel;
@property (nonatomic, strong) LWHomeWalletModel *walletModel;

@end

@implementation LWMultipySendToBeSignedView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.closeBtn.layer.borderColor = lwColorGrayD8.CGColor;
}

- (void)setSignedViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel{
    self.messagemodel = messageModel;
    self.walletModel = walletModel;
    
    self.walletNameLabel.text = walletModel.name;

    NSDictionary *userStatues = messageModel.user_status;
    NSArray *approve = [userStatues objectForKey:@"approve"];
            
    self.satuedescribeLabel.text = [NSString stringWithFormat:@"%@",kLocalizable(@"wallet_detail_Awaitingothers")];
    
    self.timeLabel.text = [LWTimeTool EngLishMonthWithTimeStamp:messageModel.createtime abbreviations:YES EnglishShortNameForDate:NO];
    self.amountLabel.text = [NSString stringWithFormat:@"-%@", [LWNumberTool formatSSSFloat:self.messagemodel.value/1e8]];

//    LWutxoModel *model = messageModel.
    
    self.addressLabel.text = messageModel.biz_data;
    self.createTimeLabel.text = [LWTimeTool dataFormateMMDDYYHHSS:messageModel.createtime];
    
    self.signCountLabel.text =  [NSString stringWithFormat:@"%ld/%ld %@",(long)approve.count,(long)walletModel.threshold,kLocalizable(@"wallet_detail_signed")];
    self.noteLabel.text = messageModel.note;
    self.txLinkLabel.text = [messageModel.txid stringByReplacingCharactersInRange:NSMakeRange(2, messageModel.txid.length - 6) withString:@"****"];
    self.amountDetailLabel.text = [NSString stringWithFormat:@"- %@ BSV  |  -%@",[LWNumberTool formatSSSFloat:messageModel.value/1e8], [LWCurrencyTool getCurrentSymbolCurrencyAmountWithUSDAmount:messageModel.price.floatValue * messageModel.value/1e8]];
}

- (IBAction)closeClick:(UIButton *)sender {
    if (self.block) {
        self.block(0);
    }
}
- (IBAction)statueClick:(UIButton *)sender {
    
    [LWAlertTool alertSigneseStatueView:self.walletModel andMessageModel:self.messagemodel andComplete:^(id  _Nonnull complete) {
        
    }];
    return;
    
    
    if (self.block) {
        self.block(1);
    }
}

- (IBAction)copyClick:(UIButton *)sender {
    
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    [paste setString:self.messagemodel.txid];
    [WMHUDUntil showMessageToWindow:kLocalizable(@"common_CopySuccess")];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
