//
//  LWCreateMultipyWalletViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWCreateMultipyWalletViewController.h"
#import "LWInputTextView.h"

@interface LWCreateMultipyWalletViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *walletNameTF;
@property (weak, nonatomic) IBOutlet UITextField *signCountTF;
@property (weak, nonatomic) IBOutlet UITextField *memberCountTF;

@property (weak, nonatomic) IBOutlet UIView *inputEmailView;
@property (nonatomic, strong) LWInputTextView   *emailTV;

@property (nonatomic, strong) NSArray   *emailArr;
@property (weak, nonatomic) IBOutlet UIView *nameBackView;
@property (weak, nonatomic) IBOutlet UIView *totalBackView;
@property (weak, nonatomic) IBOutlet UIView *membersBackView;

@property (weak, nonatomic) IBOutlet UILabel *createSharedLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *otheremailLabel;
@property (weak, nonatomic) IBOutlet UILabel *signMeberLabel;

@end

@implementation LWCreateMultipyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.createSharedLabel.text = kLocalizable(@"wallet_create_sharedaccount");
    self.accountNameLabel.text = kLocalizable(@"wallet_create_accountName");
    self.totalMemberLabel.text = kLocalizable(@"wallet_create_totalMem");
    self.otheremailLabel.text = kLocalizable(@"wallet_create_otherMem");
    self.signMeberLabel.text = kLocalizable(@"wallet_create_signMem");

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multipyWalletCreate:) name:kWebScoket_createMultiPartyWallet object:nil];

    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    self.emailTV = [[LWInputTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20*2, 210)];
    __weak typeof(self) weakself = self;
    self.emailTV.emailBlock = ^(NSArray * _Nonnull emailArray) {
        weakself.emailArr = emailArray;
        [weakSelf refreshLastCount];
    };
    [self.inputEmailView addSubview:self.emailTV];
    _memberCountTF.delegate = self;
    [self initLayer];
}

- (void)initLayer{
    self.nameBackView.layer.borderColor = lwColorGrayD8.CGColor;
    self.totalBackView.layer.borderColor = lwColorGrayD8.CGColor;
    self.membersBackView.layer.borderColor = lwColorGrayD8.CGColor;

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger maxmembers = textField.text.integerValue;
    if (maxmembers < 2) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_create_Greate1")];
        return;
    }
    self.emailTV.maxEmailCount = maxmembers;
    [self refreshLastCount];
    
}

- (IBAction)completeClick:(UIButton *)sender {
    if (self.walletNameTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_create_PleaseInputAccountName")];

        return;
    }
    if(self.signCountTF.text.length == 0){
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_create_PleaseInputSignCount")];

        return;
    }
    if (self.memberCountTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_create_PleaseInputTotalMembers")];

        return;
    }

    if (self.emailArr.count == 0) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_create_inputRemind")];
        return;
    }
    
    for (NSInteger i = 0; i < self.emailArr.count; i++) {
        if (![LWEmailTool isEmail:self.emailArr[i]]) {
            [WMHUDUntil showMessageToWindow:[NSString stringWithFormat:@"%@:%@",kLocalizable(@"login_InvalidEmail"),self.emailArr[i]]];
            return;
        }
    }
    
    if (self.signCountTF.text.integerValue > self.memberCountTF.text.integerValue) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_create_lessThanMemberCount")];
        return;
    }
    
    if (self.emailArr.count != self.memberCountTF.text.integerValue-1) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_create_lessThanMemberCount")];

        return;
    }
    [SVProgressHUD show];
    //    name    是    string    钱包名称
    //    token    是    string    币种
    //    share    是    integer    多方个数，大于等于2
    //    threshold    是    integer    至少签名的多方个数，大于等于2
    //    parties    是    array    参与的多方的账号数组
        NSDictionary *params = @{@"name":self.walletNameTF.text,
                                 @"token":@"bsv",
                                 @"share":@(self.memberCountTF.text.integerValue),
                                 @"threshold":@(self.signCountTF.text.integerValue),
                                 @"parties":self.emailArr};
        
        NSArray *requetCurrentPriceArray = @[@"req",
                                             @(WSRequestIdWalletQueryCreatMultipyWallet),
                                             @"wallet.createMultiParty",
                                             [params jsonStringEncoded]];
        
        [[SocketRocketUtility instance] sendData:[requetCurrentPriceArray mp_messagePack]];
    
    
    
}

- (void)refreshLastCount{
    NSInteger maxmembers = self.memberCountTF.text.integerValue;
    NSInteger emailCount = self.emailArr.count;
    
    NSString *string = [NSString stringWithFormat:@"%ld of %ld members added. Please add %ld more members",(long)(emailCount + 1),(long)maxmembers,(long)(maxmembers - 1 - emailCount)];
//    self.memberCountLabel.text = string;
}

- (void)multipyWalletCreate:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    NSDictionary *resInfo = notification.object;
    if ([[resInfo objectForKey:@"success"] integerValue] == 1) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_creare_AccountCreateSuccess")];

        NSDictionary *multipyparams = @{@"type":@2};
         NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
         [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

    }else{
        NSString *message = [resInfo objectForKey:@"message"];
        if (message && message.length>0) {
            [WMHUDUntil showMessageToWindow:message];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
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
