//
//  LWHomeViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeViewController.h"
#import "LWHomeListView.h"
#import "LWHomeListHeadView.h"
#import "LWAlertTool.h"

#import "LWWebSoketTool.h"


#import "LWPersonalCollectionViewController.h"
#import "LWCreateMultipyWalletViewController.h"
#import "LWCreatePersonalWalletViewController.h"

#import "PublicKeyView.h"
#import "PubkeyManager.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"

#import "QQLBXScanViewController.h"
#import "LBXPermission.h"

#import "NSData+HexString.h"

#import "LWMultipyAdressTool.h"
#import "LWMultipySignTool.h"
#import "iCloudHandle.h"

@interface LWHomeViewController (){
    NSOperationQueue * queue;
    dispatch_semaphore_t signSemphore;

}

@property (nonatomic, strong) LWHomeListView *listView;
@property (nonatomic, strong) LWHomeListHeadView *listHeadView;
@property (nonatomic, assign) BOOL isfirstLaunch;

@end

@implementation LWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLogin) name:KUserAccountLogIn object:nil];

    [self createUI];
    [self getprikey];

    
//    NSDictionary *params = @{@"type":@1};
//    NSArray *requestPersonalWalletArray = @[@"req",
//                                            @(WSRequestIdWalletQueryPersonalWallet),
//                                            @"wallet.query",
//                                            [params jsonStringEncoded]];
//    NSData *data = [requestPersonalWalletArray mp_messagePack];
//    [[LWWebSoketTool shareInstance] webscoketSendData:requestPersonalWalletArray andSuccessBlock:^(id  _Nonnull result) {
//
//    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_isfirstLaunch) {
        NSString *icloudRecoverStr = [LWPublicManager getRecoverQRCodeStr];
        [iCloudHandle setUpKeyValueICloudStoreWithKey:[[LWUserManager shareInstance] getUserModel].email value:icloudRecoverStr];
        _isfirstLaunch = YES;
    }
    

}

- (void)createUI{
    self.view.backgroundColor = lwColorBackground;
    
    __weak typeof(self) weakself = self;
    self.listHeadView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LWHomeListHeadView class]) owner:nil options:nil].lastObject;
//    self.listHeadView.frame = CGRectMake(0, 0, kScreenWidth, 196);
    [self.view addSubview:self.listHeadView];
    self.listHeadView.block = ^(NSInteger selectIndex) {
        [weakself.listView changeCurrentSelectData:selectIndex];
    };
    
    [self.listHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@196);
    }];
    
    self.listView = [[LWHomeListView alloc] initWithFrame:CGRectMake(0, 196, kScreenWidth, kScreenHeight - kTabBarHeight - 196) style:UITableViewStyleGrouped];
    [self.view addSubview:self.listView];
    
    UIBarButtonItem *addBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addWaletClick)];
    self.navigationItem.leftBarButtonItem = addBarItem;
    
    UIBarButtonItem *scanBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_scan_white"] style:UIBarButtonItemStylePlain target:self action:@selector(scanClick)];
    self.navigationItem.rightBarButtonItem = scanBarItem;
}

#pragma mark - homemethod
- (void)addWaletClick{
    [LWAlertTool alertHomeChooseWalletView:^(NSInteger index) {
        if (index == 1) {
            LWCreatePersonalWalletViewController *multipyVC = [[LWCreatePersonalWalletViewController alloc] init];
            multipyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:multipyVC animated:YES];
        }
        if (index == 2) {
            LWCreateMultipyWalletViewController *multipyVC = [[LWCreateMultipyWalletViewController alloc] init];
            multipyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:multipyVC animated:YES];
        }
    }];
}

- (void)scanClick{
    [LWScanTool startScan:^(id  _Nonnull result) {
        
    }];
    //[self jumpToScanPermission];
}

- (void)jumpToScanPermission {
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf jumpToScan];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"Notice" msg:@"No camera permissions, whether to go to Settings" cancel:@"Cancel" setting:@"Setting" ];
        }
    }];
    

}
- (void)jumpToScan{
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
    vc.libraryType = SLT_ZXing;
    vc.style = [QQLBXScanViewController qqStyle];
    //镜头拉远拉近功能
    vc.isVideoZoom = YES;
    [self.navigationController pushViewController:vc animated:YES];
    vc.scanresult = ^(LBXScanResult *result) {
        
    };
}

#pragma mark - startwebsocket
- (void)appLogin{
    [self getprikey];
}

- (void)getprikey{
    [SVProgressHUD show];
    NSString *prikey = [LWPublicManager getPKWithZhuJiCi];
    [self getSignWithPriKey:prikey];
}

- (void)getSignWithPriKey:(NSString *)prikey{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)a]; //转为字符型
   
    NSString *sig = [LWPublicManager getSigWithMessage:timeString];
    [self startWebScoket:sig andmessage:timeString];
}

- (void)startWebScoket:(NSString *)sig andmessage:(NSString *)message{
    NSString *uid = [[LWUserManager shareInstance] getUserModel].login_token;
    NSString *requestStr = [NSString stringWithFormat:@"%@t=%@&sig=%@&uid=%@",kWSAddress,message,sig,uid];
//    NSString *requestStr = [NSString stringWithFormat:@"ws://192.168.0.106:7001/?t=%@&sig=%@&uid=%@",message,sig,uid];
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:requestStr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidColose:) name:kWebSocketDidCloseNote object:nil];

}

- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    [self requestPersonalWalletInfo];
    [self requestMulipyWalletInfo];
}

- (void)requestPersonalWalletInfo{
    NSDictionary *params = @{@"type":@1};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestIdWalletQueryPersonalWallet),
                                            @"wallet.query",
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SocketRocketUtility instance] sendData:data];
    });
}

- (void)requestMulipyWalletInfo{
    NSDictionary *multipyparams = @{@"type":@2};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    });
}

#pragma mark - websocketDelegate
- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    id responseData = note.object;
    if ([responseData isKindOfClass:[NSArray class]]) {
        NSArray *responseArray = (NSArray *)responseData;
        NSString *firstObj = [responseData objectAtIndex:0];
        NSLog(@"ws_recieve_data:%@",note.object);
        if ([firstObj isEqualToString:@"res"]) {
            [self manageData:responseArray];
        }else if ([firstObj isEqualToString:@"update"]){
//            [self manageData:responseArray];
        }else if ([firstObj isEqualToString:@"incoming"]){
//            <__NSArrayM 0x282ed9320>(
//            12,//id
//            9744735,//聪
//            3f1ba570632e27278cc0a824177589f1a843232ffcb368f4a32f35b338aee8c8
//            )
            [self requestPersonalWalletInfo];
            [self requestMulipyWalletInfo];
            
        }else if ([firstObj isEqualToString:@"key"]){//多方签名address
            NSArray *dataArray = [responseArray objectAtIndex:1];
            LWMultipyAdressTool *addressTool = [[LWMultipyAdressTool alloc] initWithInitInfo:dataArray];
            addressTool.addressBlock = ^(NSString * _Nonnull address) {
                NSString *key_adress = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCreateMulitpyAddress_userdefault];
                if (key_adress && key_adress.length>0) {
                    LWPersonalCollectionViewController *personVC = [LWPersonalCollectionViewController shareInstanceWithCodeStr:address];
                             [LogicHandle presentViewController:personVC animate:YES];
                }
            } ;

            
        }else if ([firstObj isEqualToString:@"sign"]){//多方签名
            NSArray *dataArray = [responseArray objectAtIndex:1];

            [self manageSignInfo:dataArray];
            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSArray *dataArray = [responseArray objectAtIndex:1];
//                self->signSemphore = dispatch_semaphore_create(0);
//                LWMultipySignTool *signTool = [[LWMultipySignTool alloc] initWithInitInfo:dataArray];
//                signTool.signBlock = ^(NSDictionary * _Nonnull sign) {
//                      dispatch_semaphore_signal(self->signSemphore);
//                };
//                dispatch_semaphore_wait(self->signSemphore, DISPATCH_TIME_FOREVER);
//            });
  
            
            
        }else if ([firstObj isEqualToString:@"OK"]){
            NSDictionary *responseDic = [responseArray objectAtIndex:1];
            LWUserModel *model = [[LWUserManager shareInstance] getUserModel];
            model.dk = [responseDic objectForKey:@"dk"];
            model.ek = [responseDic objectForKey:@"ek"];
            [[LWUserManager shareInstance] setUser:model];
            /*
             <__NSArrayM 0x280ee1680>(
             OK,
             {
                 createtime = 1583400289000;
                 dk = f44f519c890a1a8b4af5728a581801edcf51d2c30845b1ec42411055856b557647ed8bd2c9881e3f4be1890eb353e3a9f7633236f27ee714bcb13aad319821f8b836fff854a6c48047de3087758813a3475bcc0a96ffcefc6f601116ce3732701cc071361b81de5b996af6f2852a60e7ae090ef9a0a1d1bd0d2e768b9447755dd464fd93d1b9d48e37bf39cc193de81c8b63e66478e69ae63685545ff32e8a5d78fcfe3e7da256ba760837089e8371404b512572aa0e07dd64ebe3bbbd8e7f10bf0f7b69190fefd0d198a1da836e0cb4daf3a4ee4b82660dfe9362b7a206dbb25e09f2c42278bf3999fa8a971be7bde1ab6ff1d0fd35d9679852d8f8bd85579eb526fee4b0eaf585214e3fa3fc363c3c;
                 ek = 2ce0dd420ca4a9ed5bf8248125f4822d79097cb3bcc80fe594ff11cd807abc5aea1ff8f0f1586de80e38643bb589aed03b183f5885ac17d5bfa4a85e9a9fc868176e2d9c3ed2710349ab306dc5c0d8af73fa050078a591452a7502bbf48260c1cd6880ba7ff7612739551214c71402fc8919bebb51a72a0a14ab4972d6528b19;
                 email = "36153297@qq.com";
                 id = 1005;
                 secret = f864e63049b0ef789bdb200e15a146ae;
                 status = 1;
                 updatetime = 1583400289000;
                 xpub = xpub661MyMwAqRbcH1BPTTo4CZFripMafep9fFDa15PoM7x5fmS39BZvmwmnSg6ioSQHTotmTybbwzuoifiqpmx4N2spqM1Tqq3Wgq3jmE5cUuP;
             */
        }
            
    }
}

- (void)SRWebSocketDidColose:(NSNotification *)note{
    NSLog(@"wscolose");
}

- (void)manageSignInfo:(NSArray *)signArray{
    
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        signSemphore = dispatch_semaphore_create(0);
    }
    
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
               dispatch_async(dispatch_get_global_queue(0, 0), ^{
                   LWMultipySignTool *signTool = [[LWMultipySignTool alloc] initWithInitInfo:signArray];
                   signTool.signBlock = ^(NSDictionary * _Nonnull sign) {
                       dispatch_semaphore_signal(self->signSemphore);
                   };
                   dispatch_semaphore_wait(self->signSemphore, DISPATCH_TIME_FOREVER);
               });
        
    }];
    [queue addOperation:operation];
    

}


- (void)manageData:(NSArray *)responseArray{
    NSInteger requestId = [[responseArray objectAtIndex:1] integerValue];
    switch (requestId) {
         case WSRequestIdWalletQueryPersonalWallet:
             [SVProgressHUD dismiss];
             [self managePersonalWalletData:responseArray[2]];
             break;
         case WSRequestIdWalletQueryMulpityWallet:
            [SVProgressHUD dismiss];
             [self manageMultipyWalletData:responseArray[2]];
             break;
         case WSRequestIdWalletQueryTokenPrice:
             [self manageTokenPrice:responseArray[2]];
             break;
         case WSRequestIdWalletQuerySingleAddress:
             [self manageCollectionAddress:responseArray[2]];
             break;
        case WSRequestIdWalletQuerySingleAddress_change:
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_createSingleAddress_change object:responseArray[2]];
            break;
         case WSRequestIdWalletQueryCreatMultipyWallet:
             [self manageCreateMultiyWallet:responseArray[2]];
             break;
         case WSRequestIdWalletQueryGetWalletMessageList:
             [self manageWalletMessageList:responseArray[2]];
             break;
         case WSRequestIdWalletQueryJoingNewWallet:
             [self manageJoinWalletInfo:responseArray[2]];
             break;
         case WSRequestIdWalletQueryMessageListInfo:{
             [SVProgressHUD dismiss];
             [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_messageListInfo object:responseArray[2]];
         }
               break;
         case WSRequestIdWalletQueryMessageParties:{
             [SVProgressHUD dismiss];
             [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_messageParties object:responseArray[2]];
         }
               break;
         case WSRequestIdWalletQueryUserIsOnLine:{
             [SVProgressHUD dismiss];
             [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_userIsOnLine object:responseArray[2]];
         }
               break;
         case WSRequestIdWalletQueryBoardCast:{
               [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_boardcast object:responseArray[2]];
           }
                 break;
         case WSRequestIdWalletQueryGetTheKey:{
                 [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_getTheKey object:responseArray[2]];
             }
                   break;
        case WSRequestIdWalletQueryComfirmAddress:{
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_confirmAddress object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryrequestPartySign:{
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_requestPartySign object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryGetKeyShare:{
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_getkeyshare object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryBroadcastTrans:{
//                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_boardcast_trans object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryMultipyAddress:{
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_multipyAddress object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryMultipyAddress_change:{
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_multipyAddress_change object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryBroadcastUnSignTrans:{
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_multipyUnSignTrans object:responseArray[2]];
            }
            break;
        case WSRequestId_multipy_broadcast_sig:{
//                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_MultipyBroadcast_sig object:responseArray[2]];
            }
                  break;
        case WSRequestId_multipy_pollBroadcast_sig:{
//                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_MultipyPollBroadcast_sig object:responseArray[2]];
            }
                  break;
        case WSRequestId_multipy_broadcast_address:{
//                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_MultipyBroadcast_address object:responseArray[2]];
            }
                  break;
        case WSRequestId_multipy_pollBroadcast_address:{
//                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_MultipyPollBroadcast_address object:responseArray[2]];
            }
                  break;
        case WSRequestId_scanLogin:{
//                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_scanLogin object:responseArray[2]];
            }
                  break;
        case WSRequestIdWallet_multipy_JoinWallet:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_multipy_JoinWallet object:responseArray[2]];
        }
            break;
        case WSRequestIdWallet_multipy_rejectsign:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_multipy_rejectSign object:responseArray[2]];
        }
            break;
        case WSRequestIdWallet_multipy_sign:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_multipy_sign object:responseArray[2]];
        }
            break;
        case WSRequestIdWallet_multipy_cancelTransaction:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_multipy_cancelTrans object:responseArray[2]];
        }
            break;
        case WSRequestIdWallet_resetWalletName:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_walletReName object:responseArray[2]];
        }
            break;
        case WSRequestIdWallet_CreatePersonalWallet:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_CreatePersonalWallet object:responseArray[2]];
        }
            break;
        case WSRequestId_paymail_queryByWid:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_paymail_queryByWid object:responseArray[2]];
        }
            break;
        case WSRequestId_paymail_update:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_paymail_update object:responseArray[2]];
        }
            break;
        case WSRequestId_paymail_setMain:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_paymail_setMain object:responseArray[2]];
        }
            break;
        case WSRequestId_paymail_query:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_paymail_query object:responseArray[2]];
        }
            break;
        case WSRequestId_paymail_add:{
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_paymail_add object:responseArray[2]];
        }
            break;
        case WSRequestId_paymail_toAddress:{
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_paymail_toAddress object:responseArray[2]];
        }
            break;
         default:{
             NSString *idString = [NSString stringWithFormat:@"%ld",(long)requestId];
             if (idString.length>5) {
                 NSString *firstPart = [idString substringToIndex:5];
                 if ([firstPart isEqualToString:@"20000"]) {
                     NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:responseArray[2]];
                     [mutableDic setObj:@(requestId) forKey:@"uid"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_userIsOnLine object:mutableDic];
                 }else if ([firstPart isEqualToString:@"30000"]){
                     [SVProgressHUD dismiss];
                       [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_MultipyBroadcast_sig object:responseArray];
                 }else if ([firstPart isEqualToString:@"31000"]){
                     [SVProgressHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_MultipyPollBroadcast_sig object:responseArray];
                 }else if ([firstPart isEqualToString:@"32000"]){
                     [SVProgressHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_multipySubmitSig object:responseArray];
                 }
             }
             
         }
             
             break;
     }
}

#pragma mark - websocket Manage Method
- (void)managePersonalWalletData:(NSDictionary *)personalData{
    
    [[NSUserDefaults standardUserDefaults] setObject:[personalData jsonStringEncoded] forKey:kPersonalWallet_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.listHeadView setPersonalWalletdData:personalData];
    [self.listView setPersonalWalletdData:personalData];
}

- (void)manageMultipyWalletData:(NSDictionary *)personalData{
    [SVProgressHUD dismiss];
    
    [[NSUserDefaults standardUserDefaults] setObject:[personalData jsonStringEncoded] forKey:kMultipyWallet_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.listHeadView setMultipyWalletdata:personalData];
    [self.listView setMultipyWalletdata:personalData];
}

- (void)manageTokenPrice:(NSDictionary *)tokenPrice{
    [SVProgressHUD dismiss];

    NSArray *dataArray = [tokenPrice objectForKey:@"data"];
    [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:kAppTokenPrice_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)manageCollectionAddress:(id)addressDic{
    NSLog(@"kWebScoket_createSingleAddress:%@",addressDic);
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_createSingleAddress object:addressDic];
}

- (void)manageCreateMultiyWallet:(id)requestInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_createMultiPartyWallet object:requestInfo];
    
    NSDictionary *multipyparams = @{@"type":@2};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)manageWalletMessageList:(id)requestInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_getMessageListInfo object:requestInfo];
}

- (void)manageJoinWalletInfo:(id)requestInfo{
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_joinWallet object:requestInfo];
}

- (void)manageMessageDetailInfo:(id)requestInfo{
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_messageDetail object:requestInfo];
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
