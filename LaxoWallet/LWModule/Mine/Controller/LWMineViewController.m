//
//  LWMineViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/21.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineViewController.h"
#import "LWMineSecurityViewController.h"
#import "LWMinePreferencesViewController.h"
#import "LBXScanNative.h"
#import "PublicKeyView.h"
#import "LWBaseWebViewController.h"
#import "iCloudHandle.h"
@interface LWMineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UIButton *loginoutBtn;
@end

@implementation LWMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameLabel.text = [[LWUserManager shareInstance]getUserModel].email;
#if DEBUG
    self.loginoutBtn.hidden = NO;
#else
    self.loginoutBtn.hidden = YES;
#endif
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self manageCurrentBit];
}

- (void)manageCurrentBit{

     NSString *personalWallet = [[NSUserDefaults standardUserDefaults] objectForKey:kPersonalWallet_userdefault];
     NSString *multipyWallet = [[NSUserDefaults standardUserDefaults] objectForKey:kMultipyWallet_userdefault];

    if (!personalWallet || personalWallet.length == 0 || !multipyWallet || multipyWallet.length == 0) {
        return;
    }
    
     NSDictionary *personalWalletDic = [NSJSONSerialization JSONObjectWithData:[personalWallet dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
     NSDictionary *multipyWalletDic = [NSJSONSerialization JSONObjectWithData:[multipyWallet dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
     
     NSArray *personalDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:[personalWalletDic objectForKey:@"data"]];
     NSArray *multipyDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:[multipyWalletDic objectForKey:@"data"]];
     
     CGFloat bitCount = 0;

     if (personalDataArray.count == 0) {
    
     }else{
         for (NSInteger i = 0; i<personalDataArray.count; i++) {
             LWHomeWalletModel *dataModel = [personalDataArray objectAtIndex:i];
             for (NSInteger j = 0; j<dataModel.utxo.count; j++) {
                 LWutxoModel *umodel = [dataModel.utxo objectAtIndex:j];
                 bitCount += umodel.value;
             }
         }
     }
     
     if (multipyDataArray.count == 0) {

     }else{
         for (NSInteger i = 0; i<multipyDataArray.count; i++) {
             LWHomeWalletModel *dataModel = [multipyDataArray objectAtIndex:i];
             for (NSInteger j = 0; j<dataModel.utxo.count; j++) {
                 LWutxoModel *umodel = [dataModel.utxo objectAtIndex:j];
                 bitCount += umodel.value;
             }
         }
     }

     if (bitCount>0) {
         
         NSString *tokenPrice = [LWPublicManager getCurrentCurrencyPrice];
         CGFloat personalBitCount = [NSDecimalNumber decimalNumberWithString:tokenPrice].floatValue * bitCount/1e8;
         
         NSString *priceTypeStr = @"$";
         if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
             priceTypeStr = @"¥";
         }else{
             priceTypeStr = @"$";
         }
         
         self.bitCountLabel.text = [LWNumberTool formatSSSFloat:bitCount/1e8];
         self.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",priceTypeStr,personalBitCount];
     }
}

- (IBAction)listSelect:(UIButton *)sender {
    NSInteger index = sender.tag - 11000;
    if (index == 1) {
        LWMineSecurityViewController *securityVC = [[LWMineSecurityViewController alloc]init];
        securityVC.MineVCType = 1;
        [LogicHandle pushViewController:securityVC animate:YES];
    }else if (index == 2){
        LWMinePreferencesViewController *securityVC = [[LWMinePreferencesViewController alloc]init];
        [LogicHandle pushViewController:securityVC animate:YES];
    }else if (index == 3){
        [self downLoadClick];
    }else if (index == 4){
        LWBaseWebViewController *securityVC = [[LWBaseWebViewController alloc]init];
        securityVC.url = @"https://twitter.com/Voltfinance";
        [LogicHandle pushViewController:securityVC animate:YES];
    }
}

- (IBAction)editCLick:(UIButton *)sender {
    
}

- (IBAction)eyeClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.bitCountLabel.text = @"***";
        self.priceLabel.text = @"***";
    }else{
        [self manageCurrentBit];
    }
}

- (void)downLoadClick{
    [SVProgressHUD show];
    
    NSString *ecryptResult = [LWPublicManager getRecoverQRCodeStr];
    [iCloudHandle setUpKeyValueICloudStoreWithKey:[[LWUserManager shareInstance] getUserModel].email value:ecryptResult];
               
    UIImage *qrImage = [LBXScanNative createQRWithString:ecryptResult QRSize:CGSizeMake(400, 400)];
    UIImageWriteToSavedPhotosAlbum(qrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    return;
//
//    UIImage *qrImage = [LBXScanNative createQRWithString:ecrypt QRSize:CGSizeMake(400, 400)];
//      UIImageWriteToSavedPhotosAlbum(qrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
//
//    return;
//    NSString *jsStr = [NSString stringWithFormat:@"encryptWithKey('%@','%@',0)",[secret md5String],seed];
//    PublicKeyView *pbView = [PublicKeyView shareInstance];
//    [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
//        if (dicData) {
//
//            [iCloudHandle setUpKeyValueICloudStoreWithKey:[[LWUserManager shareInstance] getUserModel].email value:dicData];
//
//            UIImage *qrImage = [LBXScanNative createQRWithString:dicData QRSize:CGSizeMake(400, 400)];
//            UIImageWriteToSavedPhotosAlbum(qrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
//        }else{
//
//        }
//    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [SVProgressHUD dismiss];
        NSString *msg = nil ;
        if(error){
            msg = @"Backup QR Code Fail" ;
        }else{
            msg = @"Backup QR Code Success" ;
        }
    [WMHUDUntil showMessageToWindow:msg];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)loginoutClick:(UIButton *)sender {
    [[SocketRocketUtility instance] SRWebSocketClose];
    [[LWUserManager shareInstance] clearUser];
    [LogicHandle showLoginVC];
    
}

@end
