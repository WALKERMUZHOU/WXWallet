//
//  LWMultipySendPendingView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipySendPendingView.h"

@interface LWMultipySendPendingView ()

@property (weak, nonatomic) IBOutlet UILabel *satuedescribeLabel;
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

@implementation LWMultipySendPendingView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.closeBtn.layer.borderColor = lwColorGrayD8.CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectSign:) name:kWebScoket_multipy_sign object:nil];

}

- (void)setSignedPendingViewWithWalletModel:(LWHomeWalletModel *)walletModel andMessageModel:(LWMessageModel *)messageModel{
    self.messagemodel = messageModel;

    
    NSDictionary *userStatues = messageModel.user_status;
    NSArray *approve = [userStatues objectForKey:@"approve"];
            
    self.satuedescribeLabel.text = [NSString stringWithFormat:@"You’ve signed. Awaiting others to sign (%ld of %ld)",(long)approve.count,(long)walletModel.threshold];
    
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
    [self signClick];
    return;
    
    if (self.block) {
        self.block(1);
    }
}

- (IBAction)copyClick:(UIButton *)sender {
    
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    [paste setString:self.messagemodel.txid];
    
}

- (void)signClick{

    NSDictionary *params = @{@"id":self.messagemodel.messageId,@"uid":[[LWUserManager shareInstance] getUserModel].uid};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWallet_multipy_sign),WS_Home_mulpity_sign,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)rejectSign:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        [WMHUDUntil showMessageToWindow:@"Sign Success"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_Multipy_refrshWalletDetail object:nil];
        if (self.block) {
            self.block(1);
        }
    }
}



@end
