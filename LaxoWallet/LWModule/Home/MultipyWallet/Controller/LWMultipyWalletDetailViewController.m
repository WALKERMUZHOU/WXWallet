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
#import "LWSendAddressViewController.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multipyWalletUpdate:) name:kWebScoket_multipyWalletData object:nil];

}

- (void)createUI{
    self.receiveBtn.layer.borderColor = [UIColor hex:@"#D8D8D8"].CGColor;
    self.sendBtn.layer.borderColor = [UIColor hex:@"#D8D8D8"].CGColor;
    
    self.listView = [[LWMultipyWalletDetailListView alloc]initWithFrame:CGRectMake(0, 262, kScreenWidth, KScreenHeightBar - 262) style:UITableViewStyleGrouped];
    self.listView.walletId = self.contentModel.walletId;
     self.listView.homeWallteModel = self.contentModel;
    [self.view addSubview:self.listView];
    [self.listView getCurrentData];

    if(!isIphoneX){
        self.bitCountLabel.font = kBoldFont(20);
    }
    [self refreshCurrentUI];
}

- (void)refreshCurrentUI{
    if (self.contentModel.name && self.contentModel.name.length>0) {
        self.nameLabel.text = self.contentModel.name;
    }else{
        self.nameLabel.text = @"BSV";
    }
    
    self.bitCountLabel.text = [LWNumberTool formatSSSFloat:self.contentModel.personalBitCount];
    self.priceLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:self.contentModel.personalBitCount];
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
    LWSendAddressViewController *sendVC = [[LWSendAddressViewController alloc] init];
    sendVC.walletModel = self.contentModel;
    [self.navigationController pushViewController:sendVC animated:YES];
    
//    LWPersonalSendViewController *sendVC = [[LWPersonalSendViewController alloc] init];
//    sendVC.model = self.contentModel;
//    sendVC.viewType = 1;
//    [self.navigationController pushViewController:sendVC animated:YES];
}

#pragma mark - 多方钱包列表数据更新
- (void)multipyWalletUpdate:(NSNotification *)notification{
    NSDictionary *multipyDic = notification.object;
    NSArray *dataArray = [multipyDic objectForKey:@"data"];
    if (dataArray.count>0) {
        for (NSInteger i = 0; i<dataArray.count; i++) {
            LWHomeWalletModel *model = [LWHomeWalletModel modelWithDictionary:dataArray[i]];
            if (self.contentModel && self.contentModel.walletId == model.walletId) {
                self.contentModel = model;
                [self refreshCurrentUI];
                break;;
            }
        }
    }
}

#pragma mark - get多方钱包地址通知
- (void)getMulityQrCode{
    
    NSDictionary *deposit = self.contentModel.deposit;
//    NSString *address = [deposit objectForKey:@"address"];
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

#pragma mark - 地址更新
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
