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

@interface LWPersonalWalletDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (nonatomic, strong) LWPersoanDetailListView *listView;

@property (nonatomic, assign) NSInteger addressflag;
@end

@implementation LWPersonalWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)createUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSingleAddress:) name:kWebScoket_createSingleAddress object:nil];
    
    self.receiveBtn.layer.borderColor = [UIColor hex:@"#D8D8D8"].CGColor;
    self.sendBtn.layer.borderColor = [UIColor hex:@"#D8D8D8"].CGColor;
    
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
    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.contentModel.personalBitCurrency];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"$%.2f",self.contentModel.personalBitCurrency];
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
- (void)qrClick{
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
            [SVProgressHUD dismiss];
            self.contentModel.address = address;

            //刷新下首页个人钱包数据
            NSDictionary *params = @{@"type":@1};
            NSArray *requestPersonalWalletArray = @[@"req",
                                                    @(WSRequestIdWalletQueryPersonalWallet),
                                                    @"wallet.query",
                                                    [params jsonStringEncoded]];
            NSData *data = [requestPersonalWalletArray mp_messagePack];
            [[SocketRocketUtility instance] sendData:data];
            
            [LWAlertTool alertPersonalWalletViewReceive:self.contentModel ansComplete:nil];

//            LWPersonalCollectionViewController *personVC = [LWPersonalCollectionViewController shareInstanceWithCodeStr:address];
//            [LogicHandle presentViewController:personVC animate:YES];
        };
    }
}

- (IBAction)recevieClick:(UIButton *)sender {
    [self qrClick];
}

- (IBAction)sendClick:(UIButton *)sender {
   LWPersonalSendViewController *sendVC = [[LWPersonalSendViewController alloc] init];
    sendVC.model = self.contentModel;
    [self.navigationController pushViewController:sendVC animated:YES];

}

//- (void)getCurrentData{
//    [SVProgressHUD show];
//    NSDictionary *multipyparams = @{@"wid":@(self.contentModel.walletId)};
//    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMessageListInfo),WS_Home_MessageList,[multipyparams jsonStringEncoded]];
//    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
//}
//
//- (void)manageMessageListData:(NSNotification *)notification{
//    [SVProgressHUD dismiss];
//    NSDictionary *requestInfo = notification.object;
//    if ([[requestInfo objectForKey:@"success"]integerValue] == 1) {
//        NSArray *dataArray = [[requestInfo objectForKey:@"data"] objectForKey:@"rows"];
//        for (NSInteger i = 0; i<dataArray.count; i++) {
//            LWMessageModel *model = [LWMessageModel modelWithDictionary:dataArray[i]];
//            [self.listView.dataSource addObj:model];
//        }
//        [self.listView.tableView reloadData];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
