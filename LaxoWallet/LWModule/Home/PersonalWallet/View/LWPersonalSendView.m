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

#import "LivenessViewController.h"
#import "DetectionViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"

#import "TDTouchID.h"

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
@property (nonatomic, strong) LWTransactionModel *transModel;

@end

@implementation LWPersonalSendView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.cancelBtn.layer.borderColor = lwColorGrayD8.CGColor;
    if([[TDTouchID sharedInstance] td_canSupperBiometrics] == TDTouchIDSupperTypeTouchID){
        self.faceImageView.image = [UIImage imageNamed:@"home_touchId"];
        self.faceDescribeLabel.text = @"Authenticate with Touch ID to unlock";
    }
}

- (void)setWithLWTransactionModel:(LWTransactionModel *)transModel andModel:(LWHomeWalletModel *)model{
    self.homeWalletModel = model;
    self.transModel = transModel;
    
    self.addressLabel.text = transModel.address;
    if (transModel.payMail && transModel.payMail.length > 0) {
        self.addressLabel.text = transModel.payMail;
    }
    self.bitCountLabel.text = [NSString stringWithFormat:@"%@ BSV",transModel.transAmount];
    self.noteLabel.text = transModel.note;
    [self.completeBtn setTitle:[NSString stringWithFormat:@"Send %@ BSV",transModel.transAmount] forState:UIControlStateNormal];
//    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
//        self.priceLabel.text = [NSString stringWithFormat:@"%.2f CNY",transModel.transAmount.floatValue*[[LWPublicManager getCurrentCurrencyPrice] floatValue]];
//    }else{
//        self.priceLabel.text = [NSString stringWithFormat:@"%.2f USD",transModel.transAmount.floatValue*[[LWPublicManager getCurrentCurrencyPrice] floatValue]];
//    }
    self.priceLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:transModel.transAmount.floatValue];

    __weak typeof(self) weakself = self;

    if (model.type == 1) {
        self.trans = [[LWTansactionTool alloc]init];
        if (!transModel.changeAddress || transModel.changeAddress.length == 0) {
            transModel.changeAddress = model.address;
        }
        [self.trans startTransactionWithTransactionModel:self.transModel andTotalModel:self.homeWalletModel];
//            [self.trans startTransactionWithAmount:transModel.transAmount.floatValue address:transModel.address note:transModel.note andTotalModel:model andChangeAddress:transModel.changeAddress];
        self.feeLabel.text = [NSString stringWithFormat:@"Sending %@ BSV / Network fee of %@ BSV",transModel.transAmount,[LWNumberTool formatSSSFloat: self.trans.fee.integerValue/1e8]];
        self.transModel.fee = [NSString stringWithFormat:@"%@",[LWNumberTool formatSSSFloat:self.trans.fee.integerValue/1e8]];
        
        self.trans.transactionBlock = ^(BOOL success) {
            if (success) {
                
                [weakself requestPersonalWalletInfo];
                if (weakself.block) {
                    weakself.block(1);
                }
                if (weakself.ispayMail) {
                    return ;
                }
                LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
                [successVC setSuccessWithTransactionModel:weakself.transModel];
//                    [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[LWNumberTool formatSSSFloat:weakself.trans.fee.integerValue/1e8]];
                [LogicHandle pushViewController:successVC];
            }else{
                if (weakself.block) {
                     weakself.block(0);
                 }
            }
        };
    }else{
            self.mutipyTrans = [[LWMultipyTransactionTool alloc] init];
            [self.mutipyTrans startTransactionWithTranscationModek:transModel andTotalModel:model];
//            [self.mutipyTrans startTransactionWithAmount:amount.floatValue address:address note:note andTotalModel:model andChangeAddress:changeAddress];
    //        self.feeLabel.text = [NSString stringWithFormat:@"Sending %@ BSV / Network fee of %@ BSV",amount,@(self.mutipyTrans.fee.integerValue/1e8)];
            self.feeLabel.text = [NSString stringWithFormat:@"Sending %@ BSV / Network fee of %@ BSV",transModel.transAmount,[LWNumberTool formatSSSFloat: self.mutipyTrans.fee.integerValue/1e8]];
            self.transModel.fee = [LWNumberTool formatSSSFloat: self.mutipyTrans.fee.integerValue/1e8];
            self.mutipyTrans.block = ^(NSDictionary * _Nonnull transInfo) {
                if (weakself.block) {
                    weakself.block(1);
                }

                LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
                successVC.viewType = 1;
                [successVC setSuccessWithTransactionModel:weakself.transModel];
//                [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[LWNumberTool formatSSSFloat:weakself.mutipyTrans.fee.integerValue/1e8]];
                [LogicHandle pushViewController:successVC];
            };
        }
}


- (void)setAddress:(NSString *)address andAmount:(NSString *)amount andMessage:(NSString *)note andModel:(LWHomeWalletModel *)model andChangeAddress:(nonnull NSString *)changeAddress{
    self.homeWalletModel = model;
    
    self.addressLabel.text = address;
    self.bitCountLabel.text = [NSString stringWithFormat:@"%@ BSV",amount];
    self.noteLabel.text = note;
    [self.completeBtn setTitle:[NSString stringWithFormat:@"Send %@ BSV",amount] forState:UIControlStateNormal];
//    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
//        self.priceLabel.text = [NSString stringWithFormat:@"%.2f CNY",amount.floatValue*[[LWPublicManager getCurrentCurrencyPrice] floatValue]];
//    }else{
//        self.priceLabel.text = [NSString stringWithFormat:@"%.2f USD",amount.floatValue*[[LWPublicManager getCurrentCurrencyPrice] floatValue]];
//
//    }
    self.priceLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:amount.floatValue];

    __weak typeof(self) weakself = self;

    if (model.type == 1) {
        self.trans = [[LWTansactionTool alloc]init];
        if (!changeAddress || changeAddress.length == 0) {
            changeAddress = model.address;
        }
        [self.trans startTransactionWithAmount:amount.floatValue address:address note:note andTotalModel:model andChangeAddress:changeAddress];
        self.feeLabel.text = [NSString stringWithFormat:@"Sending %@ BSV / Network fee of %@ BSV",amount,[LWNumberTool formatSSSFloat: self.trans.fee.integerValue/1e8]];

        self.trans.transactionBlock = ^(BOOL success) {
            if (success) {
                
                [weakself requestPersonalWalletInfo];
                if (weakself.block) {
                    weakself.block(1);
                }
                if (weakself.ispayMail) {
                    return ;
                }
                LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
                [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[LWNumberTool formatSSSFloat:weakself.trans.fee.integerValue/1e8]];
                [LogicHandle pushViewController:successVC];
            }else{
                if (weakself.block) {
                     weakself.block(0);
                 }
            }
        };
    }else{
        self.mutipyTrans = [[LWMultipyTransactionTool alloc] init];
        
        [self.mutipyTrans startTransactionWithAmount:amount.floatValue address:address note:note andTotalModel:model andChangeAddress:changeAddress];
//        self.feeLabel.text = [NSString stringWithFormat:@"Sending %@ BSV / Network fee of %@ BSV",amount,@(self.mutipyTrans.fee.integerValue/1e8)];
        self.mutipyTrans.block = ^(NSDictionary * _Nonnull transInfo) {
            if (weakself.block) {
                weakself.block(1);
            }

            LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
            successVC.viewType = 1;
            [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[LWNumberTool formatSSSFloat:weakself.mutipyTrans.fee.integerValue/1e8]];
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
   
    [[TDTouchID sharedInstance] td_showTouchIDWithDescribe:@"Verify existing fingerprints through the Home button" FaceIDDescribe:@"Verify with existing face ID" BlockState:^(TDTouchIDState state, NSError *error) {
        if (state == TDTouchIDStateNotSupport) {    //不支持TouchID/FaceID
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Current device does not support biometric verification, please turn on biometrics" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAc = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                if (@available(iOS 10.0, *)){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }else{
                    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }

            }];
            [alertVC addAction:alertAc];
            [LogicHandle presentViewController:alertAc animate:YES];

        } else if (state == TDTouchIDStateSuccess) {    //TouchID/FaceID验证成功
            if (self.homeWalletModel.type == 1) {
                 [self.trans transStart];
             }else{
                 [self.mutipyTrans transStart];
             }
        } else if (state == TDTouchIDStateInputPassword) { //用户选择手动输入密码

        }
    }];
    
    
//    if ([[FaceSDKManager sharedInstance] canWork]) {
//         NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
//         [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
//     }
//     LivenessViewController* lvc = [[LivenessViewController alloc] init];
//     LivingConfigModel* model = [LivingConfigModel sharedInstance];
//     [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
//    lvc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [LogicHandle presentViewController:lvc animate:YES];
//    lvc.livenessBlock = ^(NSString *face_token) {
//        LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
//        userModel.face_token = face_token;
//        [[LWUserManager shareInstance] setUser:userModel];
//
//        if (self.homeWalletModel.type == 1) {
//            [self.trans transStart];
//        }else{
//            [self.mutipyTrans transStart];
//        }
//    };
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
