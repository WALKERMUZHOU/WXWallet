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
#import "LWMultipyTransactionTool.h"
#import "LWMultipypaySuccessViewController.h"

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

@property (nonatomic, strong) LWMultipyTransactionTool *mutipyTrans;

@property (nonatomic, strong) LWHomeWalletModel *homeWalletModel;
@end

@implementation LWPersonalSendView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.cancelBtn.layer.borderColor = lwColorGrayD8.CGColor;
}

- (void)setAddress:(NSString *)address andAmount:(NSString *)amount andMessage:(NSString *)note andModel:(LWHomeWalletModel *)model{
    self.homeWalletModel = model;
    
    self.addressLabel.text = address;
    self.bitCountLabel.text = [NSString stringWithFormat:@"%@ BSV",amount];
    self.noteLabel.text = note;
    [self.completeBtn setTitle:[NSString stringWithFormat:@"Send %@ BSV",amount] forState:UIControlStateNormal];

    __weak typeof(self) weakself = self;

    if (model.type == 1) {
            self.trans = [[LWTansactionTool alloc]init];
        [self.trans startTransactionWithAmount:amount.floatValue address:address note:note andTotalModel:model];
        self.feeLabel.text = [NSString stringWithFormat:@"Sending %@ BSV / Network fee of %@ BSV",amount,@(self.trans.fee.integerValue/1e8)];

        self.trans.transactionBlock = ^(BOOL success) {
            if (success) {
                
                [weakself requestPersonalWalletInfo];
                if (weakself.block) {
                    weakself.block(0);
                }
                LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
                [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[NSString stringWithFormat:@"%@",@(self.trans.fee.integerValue/1e8)]];
                [LogicHandle pushViewController:successVC];
            }
        };
    }else{
        self.mutipyTrans = [[LWMultipyTransactionTool alloc] init];
        
        [self.mutipyTrans startTransactionWithAmount:amount.floatValue address:address note:note andTotalModel:model];
//        self.feeLabel.text = [NSString stringWithFormat:@"Sending %@ BSV / Network fee of %@ BSV",amount,@(self.mutipyTrans.fee.integerValue/1e8)];
        self.mutipyTrans.block = ^(NSDictionary * _Nonnull transInfo) {
            if (weakself.block) {
                weakself.block(0);
            }

            LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
            successVC.viewType = 1;
            [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[NSString stringWithFormat:@"%@",@(self.trans.fee.integerValue/1e8)]];
            [LogicHandle pushViewController:successVC];
        };
//        self.mutipyTrans.block = ^() {
//            if (success) {
//
//                [weakself requestPersonalWalletInfo];
//                if (weakself.block) {
//                    weakself.block(0);
//                }
//                LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
//                [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[NSString stringWithFormat:@"%@",@(self.trans.fee.integerValue/1e8)]];
//                [LogicHandle pushViewController:successVC];
//            }
//        };
    }
    

    
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
    if (self.homeWalletModel.type == 1) {
        [self.trans transStart];
    }else{
        [self.mutipyTrans transStart];
    }
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
