//
//  LWPersonalWalletDetailViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalWalletDetailViewController.h"
#import "LWPersonalSendViewController.h"
#import "LWPersonalWalletEditViewController.h"

#import "LWPersoanDetailListView.h"
#import "LWMessageModel.h"
#import "LWAddressTool.h"
#import "LWAlertTool.h"

#import "LWSendViewController.h"
#import "LWSendAddressViewController.h"
@interface LWPersonalWalletDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (nonatomic, strong) LWPersoanDetailListView *listView;

@property (nonatomic, assign) NSInteger addressflag;
@property (nonatomic, assign) BOOL firstGetAddress;

@end

@implementation LWPersonalWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self firstGetAddress];
    if(!isIphoneX){
        self.bitCountLabel.font = kBoldFont(20);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSingleAddress:) name:kWebScoket_createSingleAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPersonalWallet:) name:kWebScoket_personalWalletData object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)createUI{
    
    self.receiveBtn.layer.borderColor = lwColorGrayD8.CGColor;
    self.sendBtn.layer.borderColor = lwColorGrayD8.CGColor;
    
    self.listView = [[LWPersoanDetailListView alloc]initWithFrame:CGRectMake(0, 262, kScreenWidth, KScreenHeightBar - 262) style:UITableViewStyleGrouped];
    self.listView.walletId = self.contentModel.walletId;
    self.listView.homeWallteModel = self.contentModel;
    [self.view addSubview:self.listView];
    [self.listView getCurrentData];

    if (self.contentModel.name && self.contentModel.name.length>0) {
        self.nameLabel.text = self.contentModel.name;
    }else{
        self.nameLabel.text = @"BSV";
    }
    
    self.bitCountLabel.text = [LWNumberTool formatSSSFloat:self.contentModel.personalBitCount];
    self.priceLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:self.contentModel.personalBitCount];
}

- (void)firstWalletGetReceiveAddress{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"isFirstWalletFirstOpen:%@",[[LWUserManager shareInstance]getUserModel].uid];
    NSString *isFirstWalletFirstOpen = [userdefault objectForKey:key];
    if (!isFirstWalletFirstOpen || isFirstWalletFirstOpen.length == 0) {
        
        NSString *personalStr = [[NSUserDefaults standardUserDefaults] objectForKey:kPersonalWallet_userdefault];

        NSDictionary *personalDic = [NSJSONSerialization JSONObjectWithData:[personalStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSArray *personalArray = [personalDic objectForKey:@"data"];
        NSArray *personalDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:personalArray];
        if (personalDataArray.count >0) {
            LWHomeWalletModel *model = personalDataArray.firstObject;
            if (model.walletId == self.contentModel.walletId) {
                if (!self.contentModel.deposit) {
                       self.firstGetAddress = YES;
                       [self getQrCode];
                       [userdefault setObject:key forKey:key];
                   }
            }
        }
    }
}


- (IBAction)editClick:(UIButton *)sender {
    LWPersonalWalletEditViewController *sendVC = [[LWPersonalWalletEditViewController alloc] init];
    sendVC.model = self.contentModel;
    sendVC.block = ^(NSString * _Nonnull name) {
        self.nameLabel.text = name;
    };
    [self.navigationController pushViewController:sendVC animated:YES];
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

#pragma mark - refreshNaviData
- (void)refreshPersonalWallet:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
     NSArray *dataArray = [notiDic objectForKey:@"data"];
    if (dataArray.count>0) {
        NSArray *array = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:dataArray];
        for (NSInteger i = 0; i<array.count; i++) {
            LWHomeWalletModel *model = array[i];
            if (model.walletId == self.contentModel.walletId) {
                self.contentModel = model;
                self.bitCountLabel.text = [LWNumberTool formatSSSFloat:self.contentModel.personalBitCount];
                self.priceLabel.text = [LWCurrencyTool getCurrentSymbolCurrencyWithBitCount:self.contentModel.personalBitCount];
                return;
            }
        }
    }
}

#pragma mark - get receive address
- (void)qrClick{
    [self getQrCode];
    return;
    NSString *address = [self.contentModel.deposit objectForKey:@"address"];
    self.contentModel.address = address;
//        LWSignTool *signtool = [LWSignTool shareInstance];
//        [signtool setWithAddress:address];
//        return;
    if (address && address.length >0) {
        [LWAlertTool alertPersonalWalletViewReceive:self.contentModel ansComplete:nil];
    }else{
        [self getQrCode];
    }
}

#pragma mark - 个人钱包
- (void)getQrCode{
    if (!self.firstGetAddress) {
        [SVProgressHUD show];
    }
    LWHomeWalletModel *model = self.contentModel;
    NSDictionary *params = @{@"wid":@(model.walletId)};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQuerySingleAddress),@"wallet.createSingleAddress",[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)createSingleAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSDictionary *notiDicdata = [notiDic objectForKey:@"data"];
        NSString *address = [notiDicdata ds_stringForKey:@"address"];
        if (address && address.length>0) {
            self.contentModel.address = address;
            [SVProgressHUD dismiss];

            //刷新下首页个人钱包数据
            NSDictionary *params = @{@"type":@1};
            NSArray *requestPersonalWalletArray = @[@"req",
                                                    @(WSRequestIdWalletQueryPersonalWallet),
                                                    @"wallet.query",
                                                    [params jsonStringEncoded]];
            NSData *data = [requestPersonalWalletArray mp_messagePack];
            [[SocketRocketUtility instance] sendData:data];
            
            [LWAlertTool alertPersonalWalletViewReceive:self.contentModel ansComplete:nil];
            return;
        }
        
        
        NSString *rid = [[notiDic objectForKey:@"data"] objectForKey:@"rid"];
        NSString *path = [[notiDic objectForKey:@"data"] objectForKey:@"path"] ;
        LWAddressTool *addressTool = [LWAddressTool shareInstance];
        [addressTool setWithrid:rid andPath:path];
        addressTool.addressBlock = ^(NSString * _Nonnull address) {
            [[LWAddressTool  shareInstance] attempDealloc];
            [SVProgressHUD dismiss];
            self.contentModel.address = address;
            if (self.firstGetAddress) {
                self.firstGetAddress = NO;
                return;
            }
            [LWAlertTool alertPersonalWalletViewReceive:self.contentModel ansComplete:nil];

//            LWPersonalCollectionViewController *personVC = [LWPersonalCollectionViewController shareInstanceWithCodeStr:address];
//            [LogicHandle presentViewController:personVC animate:YES];
            //刷新下首页个人钱包数据
            NSDictionary *params = @{@"type":@1};
            NSArray *requestPersonalWalletArray = @[@"req",
                                                    @(WSRequestIdWalletQueryPersonalWallet),
                                                    @"wallet.query",
                                                    [params jsonStringEncoded]];
            NSData *data = [requestPersonalWalletArray mp_messagePack];
            [[SocketRocketUtility instance] sendData:data];
        };
    }
}

- (IBAction)recevieClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [self qrClick];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}

- (IBAction)sendClick:(UIButton *)sender {
    LWSendAddressViewController *sendVC = [[LWSendAddressViewController alloc] init];
     sendVC.walletModel = self.contentModel;
     [self.navigationController pushViewController:sendVC animated:YES];
    
//   LWPersonalSendViewController *sendVC = [[LWPersonalSendViewController alloc] init];
//    sendVC.model = self.contentModel;
//    [self.navigationController pushViewController:sendVC animated:YES];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
