//
//  LWPersoanlReceiveView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersoanlReceiveView.h"
#import "LBXScanNative.h"
#import "LWPaymailModel.h"

@interface LWPersoanlReceiveView ()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodelImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymailLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *paymailCopyBtn;

@property (nonatomic, strong) LWHomeWalletModel *model;
@end

@implementation LWPersoanlReceiveView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.doneLabel.layer.borderColor = [UIColor hex:@"DBDBDB"].CGColor;
    [WMZDialogTool setView:self.backView Radii:CGSizeMake(20,20) RoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.backView.layer.cornerRadius = 20;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSatue:) name:kWebScoket_paymail_queryByWid object:nil];
    
}

- (void)setContentModel:(LWHomeWalletModel *)model{
    _model = model;
    NSString *address = model.address;
    UIImage *qrImage = [LBXScanNative createInerIconImageQRWithString:address QRSize:CGSizeMake(400, 400)];
    [self.qrcodelImgView setImage:qrImage];
    
    if (model.name && model.name.length >0) {
        self.namelabel.text = model.name;
    }else{
        self.namelabel.text = @"BSV";
    }
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@",address];
    
    if (kScreenWidth == 320) {
        address = [address stringByReplacingCharactersInRange:NSMakeRange(4, address.length-8) withString:@"*****"];
        self.addressLabel.text = [NSString stringWithFormat:@"%@",address];
    }
    
    
    [self getCurrentPaymailSatue];


}
- (IBAction)doneClick:(UIButton *)sender {
    if (self.block) {
         self.block();
     }
}
- (IBAction)addressCopy:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:_model.address];
    [WMHUDUntil showMessageToWindow:kLocalizable(@"common_CopySuccess")];
}
- (IBAction)paymailCopy:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:self.paymailLabel.text];
    [WMHUDUntil showMessageToWindow:kLocalizable(@"common_CopySuccess")];
}

#pragma mark paymail

- (void)getCurrentPaymailSatue{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(self.model.walletId)};
      NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestId_paymail_queryByWid),WS_paymail_queryByWid,[multipyparams jsonStringEncoded]];
      [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}


- (void)getUserSatue:(NSNotification *)notification{
    NSDictionary *resInfo = notification.object;
     if ([[resInfo objectForKey:@"success"] integerValue] == 1) {
         NSArray *statueArray = [resInfo objectForKey:@"data"];
         
         if ( statueArray && statueArray.count > 0) {
             for (NSInteger i = 0; i<statueArray.count; i++) {
                 LWPaymailModel *model = [LWPaymailModel modelWithDictionary:statueArray[i]];
                 model.index = i;
                 if (model.main == 1) {
                     self.paymailLabel.text = [NSString stringWithFormat:@"%@@volt.id",model.name] ;
                     self.paymailLabel.hidden = NO;
                     self.paymailCopyBtn.hidden = NO;
                     return;
                 }
             }
             
             LWPaymailModel *model = [LWPaymailModel modelWithDictionary:statueArray[0]];
             self.paymailLabel.text = [NSString stringWithFormat:@"%@@volt.id",model.name];
             self.paymailLabel.hidden = NO;
             self.paymailCopyBtn.hidden = NO;
            return;
         }
     }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
