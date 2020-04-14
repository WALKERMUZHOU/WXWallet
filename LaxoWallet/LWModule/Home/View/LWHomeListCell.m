//
//  LWHomeListCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListCell.h"
#import "LWNumberTool.h"
@interface LWHomeListCell()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *personalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalBitCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@property (weak, nonatomic) IBOutlet UIView *multipyTrustholdsView;
@property (weak, nonatomic) IBOutlet UILabel *trustholdCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@end

@implementation LWHomeListCell

- (void)setModel:(LWHomeWalletModel *)model{
    _model = model;
    switch (model.type) {
        case 1:{
            self.multipyTrustholdsView.hidden = YES;
            self.typeLabel.hidden = YES;
            self.nameLabel.hidden = YES;
            self.bitCountLabel.hidden = YES;
            self.currentPriceLabel.hidden = YES;
            self.joinButton.hidden = YES;
            self.personalNameLabel.hidden = NO;
            self.personalBitCountLabel.hidden = NO;
            if (_model.name && _model.name.length>0) {
                self.personalNameLabel.text = _model.name;
            }else{
                self.personalNameLabel.text = @"BSV";
            }
            self.personalBitCountLabel.text = [LWNumberTool formatSSSFloat:_model.personalBitCount];
            self.tipView.hidden = YES;
        }
            
            break;
        case 2:{
            self.typeLabel.hidden = NO;
            self.nameLabel.hidden = NO;
            self.bitCountLabel.hidden = NO;
            self.currentPriceLabel.hidden = NO;
            self.personalNameLabel.hidden = NO;
//            self.typeLabel.text = [NSString stringWithFormat:@"%@",(long)_model.threshold,(long)_model.share];
            self.personalNameLabel.text = _model.name;
            self.personalBitCountLabel.text =  [LWNumberTool formatSSSFloat:_model.personalBitCount];
            self.multipyTrustholdsView.hidden = NO;
            
            NSString *trustholdCount = [NSString stringWithFormat:@"%ld",(long)self.model.threshold];
            self.trustholdCountLabel.attributedText =kAttributeText(trustholdCount, 10);
            
            NSString *shareCount = [NSString stringWithFormat:@"%ld",(long)self.model.share];
            self.totalCountLabel.attributedText = kAttributeText(shareCount,10);
            if(_model.status == 0){//状态0-创建中，1-已创建，2-已删除
                self.bitCountLabel.hidden = YES;
                self.currentPriceLabel.hidden = YES;
                self.personalBitCountLabel.hidden= NO;
//                self.personalBitCountLabel.text = [NSString stringWithFormat:@"%ld方待加入",(long)_model.needToJoinCount];
                self.joinButton.hidden = _model.join;
                self.personalBitCountLabel.text = @"0";
                self.tipView.hidden = NO;

//                self.personalBitCountLabel.hidden = !_model.join;
            }else if (model.status == 1){
                self.bitCountLabel.hidden = NO;
                self.currentPriceLabel.hidden = NO;
//                self.personalBitCountLabel.hidden = YES;
                self.bitCountLabel.text = [NSString stringWithFormat:@"%@",@(_model.personalBitCount)];
                self.joinButton.hidden = YES;
                self.currentPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",_model.personalBitCurrency];
                self.tipView.hidden = YES;

            }
            

        }
            
            break;
        default:
            break;
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = lwColorBackground;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageNotiData:) name:kWebScoket_joinWallet object:nil];
    // Initialization code
}

#pragma mark - method
- (IBAction)joinClick:(UIButton *)sender {
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(_model.walletId)};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryJoingNewWallet),@"wallet.join",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    
}

- (void)manageNotiData:(NSNotification *)notification{

    NSDictionary *requestInfo = notification.object;
    if ([[requestInfo objectForKey:@"success"]integerValue] == 1) {
        [WMHUDUntil showMessageToWindow:@"加入成功"];
        [self requestMulipyWalletInfo];
    }else{
        NSString *message = [requestInfo objectForKey:@"message"];
        if (message && message.length>0) {
            [WMHUDUntil showMessageToWindow:message];
        }
    }
}

- (void)requestMulipyWalletInfo{
    NSDictionary *multipyparams = @{@"type":@2};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

@end
