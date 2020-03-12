//
//  LWHomeViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeViewController.h"
#import "LWHomeListView.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "PublicKeyView.h"
#import "PubkeyManager.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"

#import "BFCryptor.h"
#import "NSData+HexString.h"

#import <CommonCrypto/CommonCrypto.h>

@interface LWHomeViewController ()

@property (nonatomic, strong) LWHomeListView *listView;

@end

@implementation LWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self getprikey];
    
}

- (void)createUI{
    self.listView = [[LWHomeListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.listView];
}

- (void)getprikey{
    [SVProgressHUD show];
    NSString *prikey = [LWPublicManager getPKWithZhuJiCi];
    [self getSignWithPriKey:prikey];

//        [PubkeyManager getPrikeyByZhujiciSuccessBlock:^(id  _Nonnull data) {
//            NSString *prikey = [data objectForKey:@"prikey"];
//            [self getSignWithPriKey:prikey];
//        } WithFailBlock:^(id  _Nonnull data) {
//
//        }];

}

- (void)getSignWithPriKey:(NSString *)prikey{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)a]; //转为字符型
   
#warning test
    NSString *sig = [LWPublicManager getSigWithMessage:timeString];
    [self startWebScoket:sig andmessage:timeString];

//    [PubkeyManager getSigWithPK:prikey message:timeString SuccessBlock:^(id  _Nonnull data) {
//        NSString *sig = (NSString *)data;
//        [self startWebScoket:sig andmessage:timeString];
//    } WithFailBlock:^(id  _Nonnull data) {
//
//    }];
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
//    NSArray *requetCurrentPriceArray = @[@"req",@(WSRequestIdWalletQueryTokenPrice),@"wallet.tokenPrice",@""];
//    [[SocketRocketUtility instance] sendData:[requetCurrentPriceArray mp_messagePack]];
    
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

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    id responseData = note.object;
    if ([responseData isKindOfClass:[NSArray class]]) {
        NSArray *responseArray = (NSArray *)responseData;
        NSString *firstObj = [responseData objectAtIndex:0];
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
                 [SVProgressHUD dismiss];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_getTheKey object:responseArray[2]];
             }
                   break;
        case WSRequestIdWalletQueryComfirmAddress:{
                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_confirmAddress object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryrequestPartySign:{
                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_requestPartySign object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryGetKeyShare:{
                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_getkeyshare object:responseArray[2]];
            }
                  break;
        case WSRequestIdWalletQueryBroadcastTrans:{
                [SVProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebScoket_boardcast_trans object:responseArray[2]];
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
                 }
             }
             
         }
             
             break;
     }
}

#pragma mark - websocket Manage Method
- (void)managePersonalWalletData:(NSDictionary *)personalData{
    [self.listView setPersonalWalletdData:personalData];
}

- (void)manageMultipyWalletData:(NSDictionary *)personalData{
    [SVProgressHUD dismiss];
    [self.listView setMultipyWalletdata:personalData];
}

- (void)manageTokenPrice:(NSDictionary *)tokenPrice{
    [SVProgressHUD dismiss];

    NSArray *dataArray = [tokenPrice objectForKey:@"data"];
    [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:kAppTokenPrice_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)manageCollectionAddress:(id)addressDic{
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
