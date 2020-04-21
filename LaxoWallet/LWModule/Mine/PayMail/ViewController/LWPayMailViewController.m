//
//  LWPayMailViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPayMailViewController.h"
#import "LWPaymialListTableView.h"
#import "LWTansactionTool.h"

@interface LWPayMailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ownedBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyNewBtn;
@property (weak, nonatomic) IBOutlet UIView   *coverView;

@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UITextField *payMailTF;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *payMailTFBackView;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (nonatomic, strong) LWPaymialListTableView *listView;

@property (nonatomic, strong) LWHomeWalletModel *firstWallet;

@property (nonatomic, assign) BOOL currencySufficient;
@property (nonatomic, assign) BOOL isFirstPayMail;

@property (nonatomic, assign) BOOL goToRegistepayMail;
@property (weak, nonatomic) IBOutlet UILabel *paymailDescrieLabel;

@end

@implementation LWPayMailViewController{
    BOOL _keyboardIsVisible;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *payDesStr = [NSString stringWithFormat:@"%@%@",kLocalizable(@"paymail_content_1"),kLocalizable(@"paymail_content_2")];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:payDesStr attributes:@{NSFontAttributeName:kFont(12)}];
    [attribute addAttributes:@{NSFontAttributeName:kMediumFont(12)} range:[payDesStr rangeOfString:kLocalizable(@"paymail_content_1")]];
    self.paymailDescrieLabel.attributedText = attribute;
    
    
    self.ownedBtn.selected = YES;
    __weak typeof(self) weakself = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.statueLabel.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.payMailTFBackView.layer.borderColor = lwColorGrayD8.CGColor;
    
    self.payMailTF.delegate = self;
    [self refreshBuyButton];
    self.listView = [[LWPaymialListTableView alloc] initWithFrame:self.firstView.bounds style:UITableViewStyleGrouped];
    self.listView.model = self.model;
    [self.firstView addSubview:self.listView];
    self.listView.block = ^(NSInteger count) {
        if (count == 0 && self.firstWallet.walletId == self.model.walletId) {
            weakself.isFirstPayMail = YES;
            [weakself refreshBuyButton];
        }
    };
    NSString *personalStr = [[NSUserDefaults standardUserDefaults] objectForKey:kPersonalWallet_userdefault];

    NSDictionary *personalDic = [NSJSONSerialization JSONObjectWithData:[personalStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSArray *personalArray = [personalDic objectForKey:@"data"];
    NSArray *personalDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:personalArray];
    self.firstWallet = personalDataArray.firstObject;
    
    self.amountLabel.text = [NSString stringWithFormat:@"Available funds %@ from %@ ",self.firstWallet.personalPrice,self.firstWallet.name];

    CGFloat amount = 1/[LWPublicManager getCurrentUSDPrice].floatValue;
    if (amount > self.firstWallet.canuseBitCount) {
        self.currencySufficient = NO;
    }else{
        self.currencySufficient = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payMailEditResult:) name:kWebScoket_paymail_query object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMailResult:) name:kWebScoket_paymail_add object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSingleAddress:) name:kWebScoket_createSingleAddress_change object:nil];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
     _keyboardIsVisible = NO;
    
//    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//    buttonRight.backgroundColor = [UIColor redColor];
//    [self.view addSubview:buttonRight];
//    [buttonRight addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)keyboardDidShow{
    _keyboardIsVisible = YES;
}
 
- (void)keyboardDidHide{
     _keyboardIsVisible = NO;
}

- (void)buttonClick{
    self.goToRegistepayMail = YES;
    [self.view endEditing:YES];
}

- (void)refreshBuyButton{
    if (_isFirstPayMail) {
        [self.bottomBtn setTitle:kLocalizable(@"paymail_getyourfirst") forState:UIControlStateNormal];
    }else{
        CGFloat amount = 1/[LWPublicManager getCurrentUSDPrice].floatValue;
        NSString *payBSV = [NSString stringWithFormat:@"%@ %@BSV(≈$1 USD)",kLocalizable(@"paymail_cost"),[LWNumberTool formatSSSFloat:amount]];
        [self.bottomBtn setTitle:payBSV forState:UIControlStateNormal];

//        [self.bottomBtn setTitle:@"Buy for $1 USD" forState:UIControlStateNormal];
    }
}

- (IBAction)personBtnClick:(UIButton *)sender {

    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    self.buyNewBtn.selected = NO;
    [self.buyNewBtn.titleLabel setFont:kFont(16)];
    [self.ownedBtn.titleLabel setFont:kBoldFont(16)];

    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(0, 0, 115, 40);
    }];

    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}

- (IBAction)buyNewBtnClick:(UIButton *)sender {

    if (sender.isSelected) {
          return;
      }
    sender.selected = YES;
    self.ownedBtn.selected = NO;
    [self.buyNewBtn.titleLabel setFont:kBoldFont(16)];
    [self.ownedBtn.titleLabel setFont:kFont(16)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(115, 0, 115, 40);
    }];
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];

    
}
- (IBAction)buyClick:(UIButton *)sender {
    if (_keyboardIsVisible) {
        self.goToRegistepayMail = YES;
        [self.view endEditing:YES];
    }else{
        [self buyLogic];
    }
}

- (void)buyLogic{
    if (!self.payMailTF.text || self.payMailTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"paymail_pleaseinputpaymail")];
        return;
    }
    
    if ([self.statueLabel.text isEqualToString:kLocalizable(@"paymail_unavaible")] || self.statueLabel.hidden) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"paymail_unavaible")];
        return;
    }
    
    if (self.isFirstPayMail) {
        [self addpayMail];
    }else{
        if (!self.currencySufficient) {
            [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_amountLessThanAvailabel")];
            return;
        }
        [self queryChangeAddress];
    }
}

#pragma mark - textfield
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.goToRegistepayMail) {
        if (!self.payMailTF.text || self.payMailTF.text.length == 0) {
            [WMHUDUntil showMessageToWindow:kLocalizable(@"paymail_pleaseinputpaymail")];
            self.goToRegistepayMail = NO;
            return;
        }
    }
    
    if (textField.text.length>0) {
        [self verifyPaymailAddress];
    }
}

#pragma mark - verify paymail
- (void)verifyPaymailAddress{
    [SVProgressHUD show];
    NSDictionary *params = @{@"name":[NSString stringWithFormat:@"%@",self.payMailTF.text]};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestId_paymail_query),
                                            WS_paymail_query,
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)payMailEditResult:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    self.statueLabel.hidden = NO;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1 ) {
        NSInteger dataInterger = [notiDic ds_integerForKey:@"data"];
        if (dataInterger > 0) {
            self.statueLabel.text = kLocalizable(@"paymail_unavaible");
            self.statueLabel.textColor = lwColorRedLight;
            if (self.goToRegistepayMail) {
                self.goToRegistepayMail = NO;
                [WMHUDUntil showMessageToWindow:@"UnAvailable Paymail"];
            }
        }else{
            self.statueLabel.text = kLocalizable(@"paymail_avaible");
            self.statueLabel.textColor = lwColorNormal;

            if (self.goToRegistepayMail) {
                self.goToRegistepayMail = NO;
                [self buyLogic];
            }
        }
    }else{
        self.goToRegistepayMail = NO;
        self.statueLabel.text = kLocalizable(@"paymail_unavaible");
        self.statueLabel.textColor = lwColorRedLight;
    }
}

#pragma mark - registerpaymail
- (void)queryChangeAddress{
    LWHomeWalletModel *model = self.firstWallet;
     NSDictionary *params = @{@"wid":@(model.walletId),@"type":@(2)};
     NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQuerySingleAddress_change),@"wallet.createSingleAddress",[params jsonStringEncoded]];
     NSData *data = [requestPersonalWalletArray mp_messagePack];
     [[SocketRocketUtility instance] sendData:data];
}

- (void)createSingleAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
    
        NSDictionary *notiDicData = [notiDic objectForKey:@"data"];
        NSString *addresssChange = [notiDicData ds_stringForKey:@"address"];
        if (addresssChange && addresssChange.length>0) {
            [SVProgressHUD dismiss];
            [self registerPaymail:addresssChange];
            return;
        }
        
        NSString *rid = [[notiDic objectForKey:@"data"] objectForKey:@"rid"];
        NSString *path = [[notiDic objectForKey:@"data"] objectForKey:@"path"] ;

        [SVProgressHUD show];
        LWAddressTool *addressTool = [LWAddressTool shareInstance];
        [addressTool setWithrid:rid andPath:path];
        addressTool.addressBlock = ^(NSString * _Nonnull address) {
            [[LWAddressTool  shareInstance] attempDealloc];
            [SVProgressHUD dismiss];
            [self registerPaymail:address];
        };
    }
}

- (void)registerPaymail:(NSString *)changeAddress{
    
    CGFloat amount = 1/[LWPublicManager getCurrentUSDPrice].floatValue;
    
    LWTransactionModel *model = [[LWTransactionModel alloc] init];
    model.address = @"1K6wGPRxpkV6UZTSbyH52Nxa2WMiqYhbiH";
    model.transAmount = [LWNumberTool formatSSSFloat:amount];
    model.note = @"pay for paymail";
    model.changeAddress = changeAddress;
    [LWAlertTool alertPersonalWalletViewSend:self.firstWallet andTransactionModel:model andComplete:^{
       [self addpayMail];
    }];
    return;
    
//    [LWAlertTool alertPersonalWalletViewSend:self.firstWallet andAdress:@"1K6wGPRxpkV6UZTSbyH52Nxa2WMiqYhbiH" andAmount:[LWNumberTool formatSSSFloat:amount] andNote:@"pay for paymail" changeAddress:changeAddress ispaymail:YES andComplete:^{
//        
//        [self addpayMail];
//    }];
}

- (void)addpayMail{
    NSDictionary *params = @{@"name":[NSString stringWithFormat:@"%@",self.payMailTF.text],@"uid":[[LWUserManager shareInstance] getUserModel].uid,@"wid":@(self.model.walletId)};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestId_paymail_add),
                                            WS_paymail_add,
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)addMailResult:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;

    if ([[notiDic objectForKey:@"success"] integerValue] == 1 ) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"paymail_buysuccess")];
        [self.listView getCurrentPaymailSatue];
        self.payMailTF.text = @"";
        self.isFirstPayMail = NO;
        [self personBtnClick:self.ownedBtn];
        [self refreshBuyButton];
    }else{
        [WMHUDUntil showMessageToWindow:kLocalizable(@"common_fail")];
    }
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
