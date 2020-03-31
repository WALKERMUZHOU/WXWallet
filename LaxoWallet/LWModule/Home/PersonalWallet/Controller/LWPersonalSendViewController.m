//
//  LWPersonalSendViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalSendViewController.h"
#import "LWPersonalSendViewController.h"
#import "LWPersonalpaySuccessViewController.h"
#import "libthresholdsig.h"

#import "LWAlertTool.h"
#import "LWTransactionModel.h"

@interface LWPersonalSendViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UILabel *amountDescribeLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteTF;
@property (weak, nonatomic) IBOutlet UIView *switchCoverView;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *bitcoinBtn;
@property (weak, nonatomic) IBOutlet UIButton *usdBtn;

///type = 1 输入的是bsv 2输入法币
@property (nonatomic, assign) NSInteger amountType;
@property (nonatomic, strong) NSString  *address;
@property (nonatomic, assign) BOOL ispayMail;

@end

@implementation LWPersonalSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.switchCoverView.layer.borderWidth = 1;
    self.switchCoverView.layer.borderColor = lwColorNormal.CGColor;
    
    [self.usdBtn setTitle:[LWCurrencyTool getCurrentCurrencyEnglishCode] forState:UIControlStateNormal];
    
    self.amountDescribeLabel.text = [NSString stringWithFormat:@"Available %@ / Locked in Pending TX %@",[LWNumberTool formatSSSFloat:self.model.canuseBitCount],[LWNumberTool formatSSSFloat:self.model.loackBitCount]];
    self.amountTF.delegate = self;
    
    self.amountType = 1;
    
    self.amountLabel.text =[LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:0];
    
//    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
//        self.amountLabel.text  = [NSString stringWithFormat:@"¥ 0"];
//     }else{
//         self.amountLabel.text = [NSString stringWithFormat:@"$ 0"];
//     }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSingleAddress:) name:kWebScoket_createSingleAddress_change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMultipyChangeAddress:) name:kWebScoket_multipyAddress_change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getpaymailToAddress:) name:kWebScoket_paymail_toAddress object:nil];
    
    if (self.sendAddress) {
        self.addressTF.text = self.sendAddress;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    self.amountLabel.text = [LWPublicManager getCurrentCurrencyPriceWithAmount:textField.text.floatValue];
    
    if (self.amountType == 1) {
        self.amountLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:textField.text.floatValue];
    }else{
        self.amountLabel.text = [NSString stringWithFormat:@"%@ BSV",[LWCurrencyTool getBitCountWithCurrency:textField.text.floatValue]];
    }
}

- (IBAction)completeClick:(UIButton *)sender {
    if (!self.addressTF.text || self.addressTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"please input adress"];
        return;
    }
    
    if (!self.amountTF.text || self.amountTF.text.length == 0 || self.amountTF.text.floatValue == 0) {
        [WMHUDUntil showMessageToWindow:@"please input amount"];
        return;
    }
    
    
    
    NSInteger amountInteger = self.amountTF.text.floatValue * 1e8;
    
    if (self.amountType == 2) {
        amountInteger = [LWCurrencyTool getBitCountWithCurrency:self.amountTF.text.floatValue].floatValue * 1e8;
    }
    
    if (amountInteger > self.model.canuseBitCountInterger) {
        [WMHUDUntil showMessageToWindow:@"amount need less than available"];
        return;
    }
    [self queryChangeAddress];
}

- (void)queryChangeAddress{
    
    if([LWEmailTool isEmail:self.addressTF.text] && !self.address){
        [self paymailToAddress];
        return;
    }else if(!self.address || self.address.length == 0 ){
        char *address_char = address_to_script([LWAddressTool stringToChar:self.addressTF.text]);
        NSString *address_str = [LWAddressTool charToString:address_char];
        if (!address_str || address_str.length == 0) {
            [WMHUDUntil showMessageToWindow:@"Wrong Address"];
            return;
        }
        self.address = self.addressTF.text;
    }
    
    if (self.viewType == 1) {
        [self queryMultipyChangeAddress];
    }else{
        [self queryPersonalChangeAddress];
    }
}

- (IBAction)scanClick:(UIButton *)sender {
    [LWScanTool startScanInTextInputView:^(LWScanModel * _Nonnull result) {
        self.addressTF.text = result.scanResult;
    }];
}

- (IBAction)bitcoinClick:(UIButton *)sender {
    if (sender.isSelected) {
          return;
    }
    CGFloat originX = 0;
    if (sender.tag == 10000) {
        self.bitcoinBtn.selected = YES;
        self.usdBtn.selected = NO;
        [self.bitcoinBtn.titleLabel setFont:kBoldFont(10)];
        [self.usdBtn.titleLabel setFont:kFont(10)];
        originX = 0;
        self.amountType = 1;
                
        self.amountLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBCurrency:self.amountTF.text.floatValue];
        self.amountTF.text = [LWCurrencyTool getBitCountWithCurrency:self.amountTF.text.floatValue];
        
        
    }else{
        self.bitcoinBtn.selected = NO;
        self.usdBtn.selected = YES;
        [self.usdBtn.titleLabel setFont:kBoldFont(10)];
        [self.bitcoinBtn.titleLabel setFont:kFont(10)];
        originX = 65;
        self.amountType = 2;
        
        self.amountLabel.text = [NSString stringWithFormat:@"%@ BSV",self.amountTF.text];
        self.amountTF.text = [LWCurrencyTool getCurrentCurrencyWithBitCount:self.amountTF.text.floatValue];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(originX, 0, 75, 30);
    }];
    
    
    
    
}


#pragma mark - personal change address

- (void)queryPersonalChangeAddress{
    LWHomeWalletModel *model = self.model;
     NSDictionary *params = @{@"wid":@(model.walletId),@"type":@(2)};
     NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQuerySingleAddress_change),@"wallet.createSingleAddress",[params jsonStringEncoded]];
     NSData *data = [requestPersonalWalletArray mp_messagePack];
     [[SocketRocketUtility instance] sendData:data];
}

- (void)createSingleAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
    
        id notiDicData = [notiDic objectForKey:@"data"];
        if(![notiDicData isKindOfClass:[NSDictionary class]]){
            return;
        }
        NSString *addresssChange = [notiDicData ds_stringForKey:@"address"];
        if (addresssChange && addresssChange.length>0) {
            
            LWTransactionModel *model = [[LWTransactionModel alloc] init];
            model.address = self.address;
            model.transAmount = self.amountTF.text;
            if (self.amountType == 2) {
                model.transAmount = [LWCurrencyTool getBitCountWithCurrency:self.amountTF.text.floatValue];
            }
            model.note = self.noteTF.text;
            model.changeAddress = addresssChange;
            if (self.ispayMail) {
                model.payMail = self.addressTF.text;
            }
            
            
            [LWAlertTool alertPersonalWalletViewSend:self.model andTransactionModel:model andComplete:^{
                
            }];
            
//            [LWAlertTool alertPersonalWalletViewSend:self.model andAdress:self.address andAmount:self.amountTF.text andNote:self.noteTF.text changeAddress:addresssChange andComplete:^(void) {
//
//            }];
            return;
        }

        NSString *rid = [[notiDic objectForKey:@"data"] objectForKey:@"rid"];
        NSString *path = [[notiDic objectForKey:@"data"] objectForKey:@"path"] ;

        [SVProgressHUD show];
        LWAddressTool *addressTool = [LWAddressTool shareInstance];
        [addressTool setWithrid:rid andPath:path];
        addressTool.addressBlock = ^(NSString * _Nonnull address) {
            [SVProgressHUD dismiss];
        
            LWTransactionModel *model = [[LWTransactionModel alloc] init];
            model.address = self.address;
            model.transAmount = self.amountTF.text;
            model.note = self.noteTF.text;
            model.changeAddress = address;
            if (self.ispayMail) {
                model.payMail = self.addressTF.text;
            }

            [LWAlertTool alertPersonalWalletViewSend:self.model andTransactionModel:model andComplete:^{
                
            }];
            [LWAddressTool  attempDealloc];

//            [LWAlertTool alertPersonalWalletViewSend:self.model andAdress:self.address andAmount:self.amountTF.text andNote:self.noteTF.text changeAddress:address andComplete:^(void) {
//
//             }];
        };
    }
}

#pragma mark - paymailtoAddress
- (void)paymailToAddress{
    NSDictionary *params = @{@"paymail":self.addressTF.text};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestId_paymail_toAddress),WS_paymail_toAddress,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)getpaymailToAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSString *dataAddress = [notiDic objectForKey:@"data"];
        if (dataAddress && dataAddress.length >0) {
            self.address = [notiDic objectForKey:@"data"];
            self.ispayMail = YES;
            [self queryChangeAddress];
        }else{
            [WMHUDUntil showMessageToWindow:@"Wrong paymail"];
        }
    }
}


#pragma mark multipy change address
- (void)queryMultipyChangeAddress{
    LWHomeWalletModel *model = self.model;
    NSDictionary *params = @{@"wid":@(model.walletId),@"type":@(2)};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQueryMultipyAddress_change),WS_Home_getMutipyAddress,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)getMultipyChangeAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
    
        NSDictionary *notiDicData = [notiDic objectForKey:@"data"];
        NSString *addresssChange = [notiDicData ds_stringForKey:@"address"];
        if (addresssChange && addresssChange.length>0) {
            self.model.changeAddress = addresssChange;
            
            LWTransactionModel *model = [[LWTransactionModel alloc] init];
            model.address = self.address;
            model.transAmount = self.amountTF.text;
            model.note = self.noteTF.text;
            model.changeAddress = addresssChange;
            if (self.ispayMail) {
                model.payMail = self.addressTF.text;
            }

            [LWAlertTool alertPersonalWalletViewSend:self.model andTransactionModel:model andComplete:^{
                
            }];
            
            
            
//            [LWAlertTool alertPersonalWalletViewSend:self.model andAdress:self.address andAmount:self.amountTF.text andNote:self.noteTF.text changeAddress:addresssChange andComplete:^(void) {
//
//               }];
            return;
        }
        
        NSArray *userArray = [notiDicData ds_arrayForKey:@"users"];
        if (userArray.count >0) {
            NSDictionary *deposit = self.model.deposit;
            if (deposit) {
                self.model.changeAddress = [deposit objectForKey:@"address"];
                
                LWTransactionModel *model = [[LWTransactionModel alloc] init];
                model.address = self.address;
                model.transAmount = self.amountTF.text;
                model.note = self.noteTF.text;
                model.changeAddress = [deposit objectForKey:@"address"];
                if (self.ispayMail) {
                    model.payMail = self.addressTF.text;
                }

                [LWAlertTool alertPersonalWalletViewSend:self.model andTransactionModel:model andComplete:^{
                    
                }];
                
                
                
//                [LWAlertTool alertPersonalWalletViewSend:self.model andAdress:self.address andAmount:self.amountTF.text andNote:self.noteTF.text changeAddress:[deposit objectForKey:@"address"] andComplete:^(void) {
//
//                    }];
            }
            return;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
