//
//  LWPersonalSendView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalSendView.h"
#import "LWTansactionTool.h"
#import "LWPersonalpaySuccessViewController.h"

@interface LWPersonalSendView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *faceDescribeLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, strong) LWTansactionTool *trans;
@end

@implementation LWPersonalSendView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.cancelBtn.layer.borderColor = lwColorGrayD8.CGColor;
}

- (void)setAddress:(NSString *)address andAmount:(NSString *)amount andMessage:(NSString *)note andModel:(LWHomeWalletModel *)model{
    self.addressLabel.text = address;
    self.bitCountLabel.text = [NSString stringWithFormat:@"%@ BSV",amount];
    self.noteLabel.text = note;
    [self.completeBtn setTitle:[NSString stringWithFormat:@"Send %@ BSV",amount] forState:UIControlStateNormal];

    __weak typeof(self) weakself = self;
    self.trans = [[LWTansactionTool alloc]init];
    [self.trans startTransactionWithAmount:amount.floatValue address:address note:note andTotalModel:model];
    self.feeLabel.text = [NSString stringWithFormat:@"Sending %@ BSV / Network fee of %@ BSV",amount,@(self.trans.fee.integerValue/1e8)];

    self.trans.transactionBlock = ^(BOOL success) {
        if (success) {
            
            [weakself requestPersonalWalletInfo];
            if (weakself.block) {
                weakself.block(0);
            }
//            [self requestMulipyWalletInfo];
//            [WMHUDUntil showMessageToWindow:@"transfer success"];
//            [self dismissViewControllerAnimated:YES completion:nil];
            LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
            [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[NSString stringWithFormat:@"%@",@(self.trans.fee.integerValue/1e8)]];
            [LogicHandle pushViewController:successVC];
//            [self.navigationController pushViewController:successVC animated:YES];
        }
    };
    
}

- (void)requestPersonalWalletInfo{
    NSDictionary *params = @{@"type":@1};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestIdWalletQueryPersonalWallet),
                                            @"wallet.query",
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SocketRocketUtility instance] sendData:data];
    });
}

- (IBAction)completeClick:(UIButton *)sender {
    [self.trans transStart];
}


- (IBAction)cancelClick:(UIButton *)sender {
    if (self.block) {
        self.block(0);
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
