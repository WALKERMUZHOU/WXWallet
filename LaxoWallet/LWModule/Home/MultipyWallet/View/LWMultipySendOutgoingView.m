//
//  LWMultipySendOutgoingView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipySendOutgoingView.h"

@interface LWMultipySendOutgoingView ()


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;


@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *txLinkLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountDetailLabel;

@property (nonatomic, strong) LWMessageModel *messagemodel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end


@implementation LWMultipySendOutgoingView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.closeBtn.layer.borderColor = lwColorGrayD8.CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectSign:) name:kWebScoket_multipy_cancelTrans object:nil];
}


- (void)setSignedViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel{
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
    self.amountDetailLabel.text = [NSString stringWithFormat:@"- %@ BSV  |  -%@",[LWNumberTool formatSSSFloat:messageModel.value/1e8],[LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:messageModel.value/1e8]];
}

- (IBAction)closeClick:(UIButton *)sender {
    if (self.block) {
        self.block(0);
    }
}
- (IBAction)statueClick:(UIButton *)sender {
    [SVProgressHUD show];
    [self canceltrans];
    
    
//    if (self.block) {
//        self.block(1);
//    }
}

- (void)canceltrans{

    NSDictionary *params = @{@"id":self.messagemodel.messageId};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWallet_multipy_cancelTransaction),WS_Home_mulpity_cancelTrans,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)rejectSign:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        [WMHUDUntil showMessageToWindow:@"Transaction cancel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_Multipy_refrshWalletDetail object:nil];
        if (self.block) {
            self.block(1);
        }
    }
}

- (IBAction)copyClick:(UIButton *)sender {
    
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    [paste setString:self.messagemodel.txid];
    [WMHUDUntil showMessageToWindow:@"Copy Success"];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
