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
    
#if DEBUGER
    self.loginoutBtn.hidden = YES;
#else
    self.loginoutBtn.hidden = YES;
#endif
    
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
        LWMineSecurityViewController *securityVC = [[LWMineSecurityViewController alloc]init];
        securityVC.MineVCType = 2;
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
//        if (self.currentViewType == LWHomeListViewTypePersonalWallet) {
//            [self setCurrentArray:self.personalDataArray];
//        }else{
//            [self setCurrentArray:self.multipyDataArray];
//        }
    }
}

- (void)downLoadClick{
    [SVProgressHUD show];
#warning secret 得到的途径
    
    NSString *seed = [[LWUserManager shareInstance] getUserModel].jiZhuCi;
    NSString *secret = [[LWUserManager shareInstance] getUserModel].secret;

//    NSString *ecrypt = [LWEncryptTool encrywithTheKey:secret message:seed andHex:1];
//
//    UIImage *qrImage = [LBXScanNative createQRWithString:ecrypt QRSize:CGSizeMake(400, 400)];
//      UIImageWriteToSavedPhotosAlbum(qrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
//
//    return;
    NSString *jsStr = [NSString stringWithFormat:@"encryptWithKey('%@','%@',0)",[secret md5String],seed];
    PublicKeyView *pbView = [PublicKeyView shareInstance];
    [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            UIImage *qrImage = [LBXScanNative createQRWithString:dicData QRSize:CGSizeMake(400, 400)];
            UIImageWriteToSavedPhotosAlbum(qrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }else{

        }
    }];
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
