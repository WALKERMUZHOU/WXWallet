//
//  LWHomeListHeaderView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListHeaderView.h"
#import "PopoverView.h"
#import "TYAlertController.h"
#import "LogicHandle.h"
#import "LWNewMultiPartyWalletViewController.h"
#import "QQLBXScanViewController.h"
#import "LBXPermission.h"

@interface LWHomeListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end


@implementation LWHomeListHeaderView

- (void)setCurrentType:(NSInteger)currentType{
    _currentType = currentType;
}

- (void)setCurrentArray:(NSArray *)currentArray{
    if (currentArray.count == 0) {
        self.amountLabel.text = @"0";
        return;
    }
    
    CGFloat bitCount = 0;
    for (NSInteger i = 0; i<currentArray.count; i++) {
        LWHomeWalletModel *dataModel = [currentArray objectAtIndex:i];
        for (NSInteger j = 0; j<dataModel.utxo.count; j++) {
            LWutxoModel *umodel = [dataModel.utxo objectAtIndex:j];
            bitCount += umodel.value;
        }
    }
    
    NSArray *tokenArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAppTokenPrice_userdefault];
    if (tokenArray.count>0) {
        NSDictionary *tokenDic = [tokenArray objectAtIndex:0];
        NSString *tokenPrice = [tokenDic objectForKey:@"cny"];
        CGFloat personalBitCount = [NSDecimalNumber decimalNumberWithString:tokenPrice].floatValue * bitCount/1e8;
        self.amountLabel.text = [NSString stringWithFormat:@"%.2f",personalBitCount];
    }
}

- (IBAction)walletSwitchClick:(UIButton *)sender {
    
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:nil message:nil];
    alertView.isManualDesign1 = YES;
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"个人钱包" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        if (sender.selected == NO) {
            return ;
        }
        self.currentType = 1;
        sender.selected = NO;
        self.walletName.text = @"个人钱包";
        if (self.headerBlock) {
            self.headerBlock(1);
        }
        NSLog(@"%@",action.title);
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"多人控制钱包" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
        if (sender.selected == YES) {
            return ;
        }
        sender.selected = YES;
        self.currentType = 2;
        self.walletName.text = @"多人控制钱包";
        if (self.headerBlock) {
            self.headerBlock(2);
        }
    }]];

    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [LogicHandle presentViewController:alertController animate:YES];
}



- (IBAction)rightClick:(UIButton *)sender {
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"home_newWallet"] title:@"新钱包" handler:^(PopoverAction *action) {
        [self jumoToNewWallet];
       }];
    PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"home_scan"] title:@"扫码" handler:^(PopoverAction *action) {
        [self jumpToScanPermission];
       }];
       
   PopoverView *popoverView = [PopoverView popoverView];
   popoverView.style = PopoverViewStyleDark;
   // 在没有系统控件的情况下调用可以使用显示在指定的点坐标的方法弹出菜单控件.
   [popoverView showToView:sender withActions:@[action1, action2]];
}

- (void)jumoToNewWallet{
    LWNewMultiPartyWalletViewController *newWalletVC = [[LWNewMultiPartyWalletViewController alloc]init];
    [LogicHandle pushViewController:newWalletVC];
}

- (void)jumpToScanPermission {
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf jumpToScan];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];
    

}
- (void)jumpToScan{
        QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = SLT_ZXing;
    //       vc.scanCodeType = [Global sharedManager].scanCodeType;

        vc.style = [QQLBXScanViewController qqStyle];
           
           //镜头拉远拉近功能
        vc.isVideoZoom = YES;
        [LogicHandle pushViewController:vc];
}
@end
