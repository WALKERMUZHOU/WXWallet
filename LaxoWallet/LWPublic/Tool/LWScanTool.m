//
//  LWScanTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWScanTool.h"
#import "QQLBXScanViewController.h"
#import "LBXPermission.h"
#import "libthresholdsig.h"
#import "LWScanModel.h"
#import "LWScanResultViewController.h"
#import "LWScanLoginViewController.h"
#import "LWPersonalSendViewController.h"
#import "LWSendAddressViewController.h"

typedef void(^LWScanResultBlock)(LWScanModel *model);

@interface LWScanTool()

@property (nonatomic, copy) LWScanResultBlock resultBlock;
@property (nonatomic, assign) BOOL inTextField;
@end

@implementation LWScanTool

+ (void)startScan:(void (^)(id _Nonnull))scanResult{
    LWScanTool *scan = [[LWScanTool alloc] init];
    [scan scanPermission:^(BOOL permmit) {
        if (permmit) {
            [scan jumpToScan];
            scan.resultBlock = ^(LWScanModel *model) {
                [scan manageScanReult:model];
                scanResult(model);
            };
        }
    }];
}

+ (void)startScanInTextInputView:(void (^)(LWScanModel * _Nonnull))scanResult{
    LWScanTool *scan = [[LWScanTool alloc] init];
    scan.inTextField = YES;
    [scan scanPermission:^(BOOL permmit) {
        if (permmit) {
            [scan jumpToScan];
            scan.resultBlock = ^(LWScanModel *model) {
                scanResult(model);
            };
        }
    }];
}

- (void)scanPermission:(void (^)(BOOL permmit))permissionResult {
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            permissionResult(YES);
        }
        else if(!firstTime)
        {
            permissionResult(NO);
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];
}

- (void)jumpToScan{
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
    vc.libraryType = SLT_Native;
    vc.style = [QQLBXScanViewController qqStyle];
    //镜头拉远拉近功能
    vc.isVideoZoom = YES;
    [LogicHandle pushViewController:vc];
    vc.scanresult = ^(LBXScanResult *result) {
        LWScanModel *model = [self getScanReult:result.strScanned];
        if (self.resultBlock) {
            self.resultBlock(model);
        }
    };
}

- (LWScanModel *)getScanReult:(NSString *)scanResult{
    LWScanModel *scanModel = [[LWScanModel alloc] init];

    if (scanResult && scanResult.length >0) {
        NSString *handleString;
        if (@available(iOS 9,*)){
            handleString = [scanResult stringByRemovingPercentEncoding];
        }else{
            handleString = [scanResult stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }

        if(([handleString containsString:@"http://"]||[handleString containsString:@"https://"])){
            NSArray *urlComps = [handleString componentsSeparatedByString:@"?"];
            NSString *headerString = [urlComps objectAtIndex:0];
            if ([headerString hasPrefix:@"https://laxo.io"] || [headerString hasPrefix:@"http://laxo.io"] || [headerString hasPrefix:@"https://voltwallet.io/login"] ||[headerString hasPrefix:@"http://voltwallet.io/login"] || [headerString hasPrefix:@"https://volt.id/login"] ||[headerString hasPrefix:@"http://volt.id/login"]) {//
                if([urlComps count]){
                    NSArray *paramArray = [[urlComps objectWithIndex:1] componentsSeparatedByString:@"&"];
                    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
                    for (int i=0; i<[paramArray count]; i++) {
                       NSArray *paramStr = [[paramArray objectWithIndex:i] componentsSeparatedByString:@"="];
                       NSString *name = [paramStr objectWithIndex:0];
                       NSString *value = [paramStr objectWithIndex:1];
                       if (name && value) {
                           [paramDic setObject:value forKey:name];
                       }
                    }
                    if (paramArray.count > 0 && paramDic.allKeys.count>0) {
                        if ([[paramDic objectForKey:@"key"] isEqualToString:@"login"]) {
                            NSString *returnId = [paramDic objectForKey:@"id"];
                            scanModel.scanType = 2;
                            scanModel.scanResult = returnId;
                        }
//                        scanModel.scanType = 1;
//                        scanModel.scanResult = [paramDic objectForKey:@"id"];;
                    }
                }
            }
        }else{
            char *addressMB = address_to_script([LWAddressTool stringToChar:scanResult]);
            NSString *addressMB_str = [LWAddressTool charToString:addressMB];
            if (addressMB_str && addressMB_str.length >0) {
                scanModel.scanType = 1;
                scanModel.scanResult = scanResult;
            }
        }
    }
    
    if (scanModel.scanType == 0 || !scanModel.scanType) {
        scanModel.scanType = 10000;
        scanModel.scanResult = scanResult;
    }
    return scanModel;

}

- (void)manageScanReult:(LWScanModel *)model{
    if (self.inTextField) {
        if (self.resultBlock) {
            self.resultBlock(model);
        }
        return;
    }
    
    if (model.scanType == 2) {
        LWScanLoginViewController *loginVC = [[LWScanLoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        loginVC.scanId = model.scanResult;
        [LogicHandle presentViewController:[[LWNavigationViewController alloc] initWithRootViewController:loginVC] animate:NO];
    }else if(model.scanType == 1){
        
        LWSendAddressViewController *sendVC = [[LWSendAddressViewController alloc]init];
        sendVC.walletModel = [LWPublicManager getPersonalFirstWallet];
        sendVC.sendAddress = model.scanResult;
        sendVC.hidesBottomBarWhenPushed = YES;
        [LogicHandle pushViewController:sendVC animate:NO];
    }else{
        LWScanResultViewController *scanReusltVC = [[LWScanResultViewController alloc] init];
        scanReusltVC.contentStr = model.scanResult;
        [LogicHandle pushViewController:scanReusltVC];
    }
}
@end
