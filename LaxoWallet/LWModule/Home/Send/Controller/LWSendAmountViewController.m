//
//  LWSendAmountViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSendAmountViewController.h"
#import "LWNumberInputView.h"
#import "LWNumberOutputView.h"
#import "LWSendCheckViewController.h"

@interface LWSendAmountViewController ()

@property (nonatomic, strong) UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) NSString *bitCount;
@property (nonatomic, strong) NSString *currencyCount;


@property (nonatomic, strong) LWNumberInputView *inputView;
@property (nonatomic, strong) LWNumberOutputView *outputView;

@end

@implementation LWSendAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSingleAddress:) name:kWebScoket_createSingleAddress_change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMultipyChangeAddress:) name:kWebScoket_multipyAddress_change object:nil];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
}

- (void)createUI{
    if (kScreenWidth == 320) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@131);
        }];
        self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeightBar - 131)];
        self.scrollview.contentSize = CGSizeMake(kScreenWidth, 470);
    }else if (kScreenWidth == 375 && kScreenWidth == 667){
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@131);
        }];
        self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeightBar - 131)];
        self.scrollview.contentSize = CGSizeMake(kScreenWidth, KScreenHeightBar - 131);

    } else{
        self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeightBar - 171)];
        self.scrollview.contentSize = CGSizeMake(kScreenWidth, KScreenHeightBar - 171);
    }
    [self.view addSubview:self.scrollview];
    self.scrollview.delaysContentTouches = NO;
    self.scrollview.canCancelContentTouches = NO;
    
    UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 30)];
    sendLabel.attributedText = kAttributeBoldText(kLocalizable(@"common_Send"), 22);
    sendLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollview addSubview:sendLabel];
    
    UIView *amountBackView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 15, 100, 25)];
    amountBackView.backgroundColor = lwColorGrayF6;
    [self.scrollview addSubview:amountBackView];
    amountBackView.layer.cornerRadius = 12.5;
    amountBackView.layer.masksToBounds = YES;
    
    UIButton *amountBtn = [[UIButton alloc] init];
    [amountBtn setTitleColor:lwColorBlack forState:UIControlStateNormal];
    [amountBtn.titleLabel setFont:kFont(12)];
    [amountBackView addSubview:amountBtn];
    [amountBtn setTitle:[LWNumberTool formatSSSFloat:self.walletModel.canuseBitCount] forState:UIControlStateNormal];
    [amountBtn addTarget:self action:@selector(allAmountClick:) forControlEvents:UIControlEventTouchUpInside];
    [amountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(amountBackView);
        make.left.equalTo(amountBackView.mas_left).offset(10);
        make.right.equalTo(amountBackView.mas_right).offset(-10);
    }];
    
    CGSize amountSize = [[LWNumberTool formatSSSFloat:self.walletModel.canuseBitCount] boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(12)} context:nil].size;
    amountBackView.kwidth = amountSize.width + 20;
    amountBackView.kright = kScreenWidth - 15;

//    [amountBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollview.mas_top).offset(15);
//        make.right.equalTo(self.scrollview.mas_right).offset(15);
//        make.height.equalTo(@25);
//    }];
    
    
    __weak typeof(self) weakself = self;
    
    self.outputView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWNumberOutputView class]) owner:nil options:nil].lastObject;
    self.outputView.frame = CGRectMake(0, sendLabel.kbottom + 30,kScreenWidth , 70);
    [self.scrollview addSubview:self.outputView];
    self.outputView.block = ^(NSString * _Nonnull bitCount, NSString * _Nonnull currencyAmount) {
        weakself.bitCount = bitCount;
        weakself.currencyCount = currencyAmount;
    };
    
    self.inputView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWNumberInputView class]) owner:nil options:nil].lastObject;
    self.inputView.frame = CGRectMake(0, 160  + (self.scrollview.contentSize.height - 160 - 280)/2 ,kScreenWidth , 280);
    [self.scrollview addSubview:self.inputView];
    self.inputView.block = ^(NSString * _Nonnull inputNum) {
        [weakself.outputView setTopAmount:inputNum];
    };
}
- (IBAction)nextClick:(UIButton *)sender {
    
    if (self.bitCount.floatValue == 0) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_pleaseinputAmount")];
        return;
    }

    NSInteger amountInteger = self.bitCount.floatValue * 1e8;
    
    if (amountInteger > self.walletModel.canuseBitCountInterger) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_amountLessThanAvailabel")];
        return;
    }
    
    if (amountInteger <= 546) {
        [WMHUDUntil showMessageToWindow:kLocalizable(@"wallet_send_amountGreater546")];
        return;
    }
    
    self.model.transAmount = self.bitCount;
    
    if (self.walletModel.type == 1) {
        [self queryPersonalChangeAddress];
    }else{
        [self queryMultipyChangeAddress];
    }
}

- (void)allAmountClick:(UIButton *)sender{
    [self.outputView setBitAmount:[LWNumberTool formatSSSFloat:self.walletModel.canuseBitCount]];
}

#pragma mark - personal change address

- (void)queryPersonalChangeAddress{
    LWHomeWalletModel *model = self.walletModel;
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
            
            self.model.changeAddress = addresssChange;
            LWSendCheckViewController *checkVC = [[LWSendCheckViewController alloc] init];
            checkVC.model = self.model;
            checkVC.walletModel = self.walletModel;
            [LogicHandle pushViewController:checkVC animate:YES];
            return;
            [LWAlertTool alertPersonalWalletViewSend:self.walletModel andTransactionModel:self.model andComplete:^{
                
            }];
            
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
        
            self.model.changeAddress = address;
            LWSendCheckViewController *checkVC = [[LWSendCheckViewController alloc] init];
            checkVC.model = self.model;
            checkVC.walletModel = self.walletModel;
            [LogicHandle pushViewController:checkVC animate:YES];

            return;
            [LWAlertTool alertPersonalWalletViewSend:self.walletModel andTransactionModel:self.model andComplete:^{
                
            }];
        };
    }
}

#pragma mark multipy change address
- (void)queryMultipyChangeAddress{
    LWHomeWalletModel *model = self.walletModel;
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
            LWSendCheckViewController *checkVC = [[LWSendCheckViewController alloc] init];
             checkVC.model = self.model;
             checkVC.walletModel = self.walletModel;
             [LogicHandle pushViewController:checkVC animate:YES];

             return;
            [LWAlertTool alertPersonalWalletViewSend:self.walletModel andTransactionModel:self.model andComplete:^{
                
            }];
            
            
            
//            [LWAlertTool alertPersonalWalletViewSend:self.model andAdress:self.address andAmount:self.amountTF.text andNote:self.noteTF.text changeAddress:addresssChange andComplete:^(void) {
//
//               }];
            return;
        }
        
        NSArray *userArray = [notiDicData ds_arrayForKey:@"users"];
        if (userArray.count >0) {
            NSDictionary *deposit = self.walletModel.deposit;
            if (deposit) {
                self.model.changeAddress = [deposit objectForKey:@"address"];

                LWSendCheckViewController *checkVC = [[LWSendCheckViewController alloc] init];
                 checkVC.model = self.model;
                 checkVC.walletModel = self.walletModel;
                 [LogicHandle pushViewController:checkVC animate:YES];

                 return;
                
                
                [LWAlertTool alertPersonalWalletViewSend:self.walletModel andTransactionModel:self.model andComplete:^{
                    
                }];
                
                
                
//                [LWAlertTool alertPersonalWalletViewSend:self.model andAdress:self.address andAmount:self.amountTF.text andNote:self.noteTF.text changeAddress:[deposit objectForKey:@"address"] andComplete:^(void) {
//
//                    }];
            }
            return;
        }
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
