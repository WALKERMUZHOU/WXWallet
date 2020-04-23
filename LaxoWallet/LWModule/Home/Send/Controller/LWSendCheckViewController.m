//
//  LWSendCheckViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSendCheckViewController.h"
#import "LWHistoryAmountView.h"
#import "TDTouchID.h"
#import "LWTansactionTool.h"
#import "LWMultipyTransactionTool.h"
#import "LWPersonalpaySuccessViewController.h"

@interface LWSendCheckViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabe;
@property (weak, nonatomic) IBOutlet UILabel *bitLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *faceDescribeLabel;

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@property (nonatomic, strong) LWTansactionTool *trans;
@property (nonatomic, strong) LWMultipyTransactionTool *mutipyTrans;
@end

@implementation LWSendCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (kScreenWidth == 320) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@131);
        }];

        self.scrollView.contentSize = CGSizeMake(kScreenWidth, 500);
    }else if (kScreenWidth == 375 && kScreenWidth == 667){
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@131);
        }];

        self.scrollView.contentSize = CGSizeMake(kScreenWidth, KScreenHeightBar - 131);

    } else{
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, KScreenHeightBar - 171);
    }

    self.faceDescribeLabel.text = kLocalizable(@"wallet_send_auth_faceid");

    
    if([[TDTouchID sharedInstance] td_canSupperBiometrics] == TDTouchIDSupperTypeTouchID){
        self.faceImageView.image = [UIImage imageNamed:@"home_touchId"];
        self.faceDescribeLabel.text = kLocalizable(@"wallet_send_auth_touchid");
    }
    
    self.textView.layer.borderColor = lwColorGrayD8.CGColor;
    
    self.bitLabel.text = [NSString stringWithFormat:@"%@ BSV",self.model.transAmount];

        [self.nextBtn setTitle:[NSString stringWithFormat:@"%@ %@ BSV",kLocalizable(@"common_Send"),self.model.transAmount] forState:UIControlStateNormal];
    self.currencyLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:self.model.transAmount.doubleValue];

        __weak typeof(self) weakself = self;

    if (self.walletModel.type == 1) {
            self.trans = [[LWTansactionTool alloc]init];
            if (!self.model.changeAddress || self.model.changeAddress.length == 0) {
                self.model.changeAddress = self.walletModel.address;
            }
            [self.trans startTransactionWithTransactionModel:self.model andTotalModel:self.walletModel];
            self.feeLabel.text = [NSString stringWithFormat:@"%@ %@ BSV",kLocalizable(@"wallet_send_networkfee"),[LWNumberTool formatSSSFloat: self.trans.fee.integerValue/1e8]];
            self.model.fee = [NSString stringWithFormat:@"%@",[LWNumberTool formatSSSFloat:self.trans.fee.integerValue/1e8]];
            
            self.trans.transactionBlock = ^(id success) {
                if ([success isKindOfClass:[LWTransactionModel class]]) {
                    LWTransactionModel *successModel = (LWTransactionModel *)success;
                    [weakself requestPersonalWalletInfo];
                    LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
                    [successVC setSuccessWithTransactionModel:successModel];
    //                    [successVC setSuccessWithAmount:amount andaddress:address andnote:note andfee:[LWNumberTool formatSSSFloat:weakself.trans.fee.integerValue/1e8]];
                    [LogicHandle pushViewController:successVC];
                }else{
                    [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_TransactionFail")];
                }
            };
        }else{
            self.mutipyTrans = [[LWMultipyTransactionTool alloc] init];
            [self.mutipyTrans startTransactionWithTranscationModek:self.model andTotalModel:self.walletModel];
            self.feeLabel.text = [NSString stringWithFormat:@"%@ %@ BSV",kLocalizable(@"wallet_send_networkfee"),[LWNumberTool formatSSSFloat: self.mutipyTrans.fee.integerValue/1e8]];
                self.model.fee = [LWNumberTool formatSSSFloat: self.mutipyTrans.fee.integerValue/1e8];
            self.mutipyTrans.block = ^(id  _Nonnull transInfo) {
                if ([transInfo isKindOfClass:[NSDictionary class]]) {
                     LWPersonalpaySuccessViewController *successVC = [[LWPersonalpaySuccessViewController alloc] init];
                     successVC.viewType = 1;
                     [successVC setSuccessWithTransactionModel:weakself.model];
                     [LogicHandle pushViewController:successVC];
                }else{
                    [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_TransactionFail")];
                }
            };
        }
}

#pragma mark - 刷新个人钱包
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

- (IBAction)nextClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    NSString *noteStr = self.textView.text;
    if ([noteStr hasPrefix:kLocalizable(@"wallet_send_Note")]) {
        noteStr = [noteStr stringByReplacingCharactersInRange:NSMakeRange(0, kLocalizable(@"wallet_send_Note").length) withString:@""];
    }
    self.model.note = noteStr;

    if(self.walletModel.type == 1){
        [self.trans setNoteMessage:noteStr];
    }else{
        [self.mutipyTrans setNoteMessage:noteStr];
    }
    
     [[TDTouchID sharedInstance] td_showTouchIDWithDescribe:kLocalizable(@"face_title_TouchID") FaceIDDescribe:kLocalizable(@"face_title_FaceID") BlockState:^(TDTouchIDState state, NSError *error) {
         if (state == TDTouchIDStateNotSupport) {    //不支持TouchID/FaceID
             UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kLocalizable(@"face_no_biometric") message:nil preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *alertAc = [UIAlertAction actionWithTitle:kLocalizable(@"common_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                 if (@available(iOS 10.0, *)){
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                 }else{
                     [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                 }

             }];
             [alertVC addAction:alertAc];
             [LogicHandle presentViewController:alertVC animate:YES];

         } else if (state == TDTouchIDStateSuccess) {    //TouchID/FaceID验证成功
             if (self.walletModel.type == 1) {
                  [self.trans transStart];
              }else{
                  [self.mutipyTrans transStart];
              }
         } else if (state == TDTouchIDStateInputPassword) { //用户选择手动输入密码

         }
     }];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
