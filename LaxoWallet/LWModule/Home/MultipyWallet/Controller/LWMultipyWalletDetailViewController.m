//
//  LWMultipyWalletDetailViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyWalletDetailViewController.h"
#import "LWPersonalSendViewController.h"
#import "LWMultipyEditMemberViewController.h"

#import "UIView+TYAutoLayout.h"

#import "LWMultipyWalletDetailListView.h"
#import "LWMultipyEditViewController.h"

#import "LWAlertTool.h"

@interface LWMultipyWalletDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (nonatomic, strong) LWMultipyWalletDetailListView *listView;

@end

@implementation LWMultipyWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMultipyAddress:) name:kWebScoket_multipyAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partiesNotification:) name:kWebScoket_messageParties object:nil];
    [self queryParties];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSingleAddress:) name:kWebScoket_multipyAddress_change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressUpdate:) name:kWebScoket_multipy_address_update object:nil];


}

- (void)createUI{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSingleAddress:) name:kWebScoket_createSingleAddress object:nil];
    
    self.receiveBtn.layer.borderColor = [UIColor hex:@"#D8D8D8"].CGColor;
    self.sendBtn.layer.borderColor = [UIColor hex:@"#D8D8D8"].CGColor;
    
//    UIBarButtonItem *addBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_wallet_qrcode"] style:UIBarButtonItemStylePlain target:self action:@selector(qrClick)];
////    self.navigationItem.leftBarButtonItem = addBarItem;
//
//    UIBarButtonItem *scanBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_scan_white"] style:UIBarButtonItemStylePlain target:self action:@selector(scanClick)];
//    self.navigationItem.rightBarButtonItems = @[scanBarItem,addBarItem];
    
    self.listView = [[LWMultipyWalletDetailListView alloc]initWithFrame:CGRectMake(0, 262, kScreenWidth, KScreenHeightBar - 262) style:UITableViewStyleGrouped];
    self.listView.homeWallteModel = self.contentModel;
    self.listView.walletId = self.contentModel.walletId;
    [self.view addSubview:self.listView];
    [self.listView getCurrentData];

//    if (!self.contentModel.isMineCreateWallet) {
//        self.editBtn.hidden = YES;
////        [self.nameLabel removeConstraintWithView:self.editBtn attribute:NSLayoutAttributeRight];
//        [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@0);
//        }];
//    }
    
    if (self.contentModel.name && self.contentModel.name.length>0) {
        self.nameLabel.text = self.contentModel.name;
    }else{
        self.nameLabel.text = @"BSV";
    }
    
    self.bitCountLabel.text = [LWNumberTool formatSSSFloat:self.contentModel.personalBitCount];
    self.priceLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:self.contentModel.personalBitCount];
    
    
//    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
//        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.contentModel.personalBitCurrency];
//    }else{
//        self.priceLabel.text = [NSString stringWithFormat:@"$%.2f",self.contentModel.personalBitCurrency];
//    }
    
    if(!isIphoneX){
        self.bitCountLabel.font = kBoldFont(20);
    }
    
}

- (IBAction)eyeClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
     if (sender.isSelected) {
         self.bitCountLabel.text = @"***";
         self.priceLabel.text = @"***";
     }else{
         self.bitCountLabel.text = [NSString stringWithFormat:@"%@",@(self.contentModel.personalBitCount)];
         if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
             self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.contentModel.personalBitCurrency];
         }else{
             self.priceLabel.text = [NSString stringWithFormat:@"$%.2f",self.contentModel.personalBitCurrency];
         }
     }
    
}
- (IBAction)editBtn:(UIButton *)sender {
    LWMultipyEditViewController *editVC = [[LWMultipyEditViewController alloc] init];
    editVC.model = self.contentModel;
    [self.navigationController pushViewController:editVC animated:YES];
    editVC.block = ^(NSString * _Nonnull walletName) {
        self.nameLabel.text = walletName;
    };
}

- (IBAction)receiveClick:(UIButton *)sender {
    [self getMulityQrCode];

}

- (IBAction)sendClick:(UIButton *)sender {
    LWPersonalSendViewController *sendVC = [[LWPersonalSendViewController alloc] init];
    sendVC.model = self.contentModel;
    sendVC.viewType = 1;
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)getMulityQrCode{
    
    NSDictionary *deposit = self.contentModel.deposit;
    NSString *address = [deposit objectForKey:@"address"];
//    if (address && address.length>0) {
//        self.contentModel.address = address;
//        [LWAlertTool alertPersonalWalletViewReceive:self.contentModel ansComplete:nil];
//        return;
//    }
 
    LWHomeWalletModel *model = self.contentModel;
    NSDictionary *params = @{@"wid":@(model.walletId)};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQueryMultipyAddress),WS_Home_getMutipyAddress,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];

    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kAppCreateMulitpyAddress_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)createMultipyAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSDictionary *dataDic = [notiDic objectForKey:@"data"];
        NSString *address = [dataDic ds_stringForKey:@"address"];
        
        if (!address || address.length == 0) {
            NSArray *userArray = [dataDic ds_arrayForKey:@"users"];
            NSInteger onlineUsercount = 0;
            if (userArray && userArray.count>0) {
                for (NSInteger i = 0 ; i<userArray.count ;i++) {
                    NSInteger isonline = [[userArray[i] objectForKey:@"online"] integerValue];
                    if (isonline == 1) {
                        onlineUsercount ++;
                    }
                }
                
                if (onlineUsercount < self.contentModel.threshold) {
                    [WMHUDUntil showMessageToWindow:@"please check other user online"];
                    return;
                }
            }
        }
 
        
        if (!address || address.length == 0) {


        }else{
            self.contentModel.address = address;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppCreateMulitpyAddress_userdefault];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [LWAlertTool alertPersonalWalletViewReceive:self.contentModel ansComplete:nil];
            [self queryChangeAddress];
        }
    }
}


- (void)addressUpdate:(NSNotification *)notification{
    NSArray *notiArray = notification.object;
    NSInteger walletId = [notiArray.firstObject integerValue];
    if (walletId == self.contentModel.walletId) {
        NSString *address = [notiArray objectWithIndex:2];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppCreateMulitpyAddress_userdefault];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.contentModel.address = address;
        [LWAlertTool alertPersonalWalletViewReceive:self.contentModel ansComplete:nil];
        [self queryChangeAddress];
    }
}

#pragma mark - get changeAddress

- (void)queryChangeAddress{
    LWHomeWalletModel *model = self.contentModel;
    NSDictionary *params = @{@"wid":@(model.walletId),@"type":@(2)};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQueryMultipyAddress_change),WS_Home_getMutipyAddress,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)createSingleAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
    
        NSDictionary *notiDicData = [notiDic objectForKey:@"data"];
        NSString *addresssChange = [notiDicData ds_stringForKey:@"address"];
        if (addresssChange && addresssChange.length>0) {
            self.contentModel.changeAddress = addresssChange;
            return;
        }
        
        NSArray *userArray = [notiDicData ds_arrayForKey:@"users"];
        if (userArray.count >0) {
            return;
        }
        
//        NSString *rid = [[notiDic objectForKey:@"data"] objectForKey:@"rid"];
//        NSString *path = [[notiDic objectForKey:@"data"] objectForKey:@"path"] ;
//
//        [SVProgressHUD show];
//        LWAddressTool *addressTool = [LWAddressTool shareInstance];
//        [addressTool setWithrid:rid andPath:path];
//        addressTool.addressBlock = ^(NSString * _Nonnull address) {
//            [SVProgressHUD dismiss];
//            self.contentModel.changeAddress = address;
//        };
    }
}

#pragma mark - getpartiespate
- (void)queryParties{
    [SVProgressHUD show];
    NSDictionary *params = @{@"wid":@(self.contentModel.walletId)};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQueryMessageParties),WS_Home_MessageParties,[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
    
}

- (void)partiesNotification:(NSNotification *)notification{
    [SVProgressHUD dismiss];
     NSDictionary *notiDic = notification.object;
      if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
          NSArray *partiesArray = [notiDic objectForKey:@"data"];
          self.contentModel.parties = [NSArray modelArrayWithClass:[LWPartiesModel class] json:partiesArray];
          self.listView.homeWallteModel = self.contentModel;
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
