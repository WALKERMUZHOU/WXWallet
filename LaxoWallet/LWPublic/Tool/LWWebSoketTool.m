//
//  LWWebSoketTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWWebSoketTool.h"
typedef void(^WebSocketBlock)(id result);

@interface LWWebSoketTool ()

@property (nonatomic, copy) WebSocketBlock socketBlock;
@end

@implementation LWWebSoketTool{
    
}
static LWWebSoketTool *instance = nil;
+ (LWWebSoketTool *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWWebSoketTool alloc]init];
    });
    return instance;
}


- (instancetype)init{
    self= [super init];
    if (self) {
        [self appLogin];
    }
    return self;
}

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
//    [self requestPersonalWalletInfo];
//    [self requestMulipyWalletInfo];
}

- (void)webscoketSendData:(NSArray *)params andSuccessBlock:(void (^)(id _Nonnull))block{
    
    NSData *data = [params mp_messagePack];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[SocketRocketUtility instance] sendData:data];
            
            self.socketBlock = ^(id result) {
                block(result);
            };
    
    });
    
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
            if(self.socketBlock){
                self.socketBlock(responseArray);
            }
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
//            NSArray *dataArray = [responseArray objectAtIndex:1];
//            LWMultipyAdressTool *addressTool = [[LWMultipyAdressTool alloc] initWithInitInfo:dataArray];
//            addressTool.addressBlock = ^(NSString * _Nonnull address) {
//                NSString *key_adress = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCreateMulitpyAddress_userdefault];
//                if (key_adress && key_adress.length>0) {
//                    LWPersonalCollectionViewController *personVC = [LWPersonalCollectionViewController shareInstanceWithCodeStr:address];
//                             [LogicHandle presentViewController:personVC animate:YES];
//                }
//            } ;

            
        }else if ([firstObj isEqualToString:@"sign"]){//多方签名
            NSArray *dataArray = [responseArray objectAtIndex:1];

            [self manageSignInfo:dataArray];
        }else if ([firstObj isEqualToString:@"OK"]){
            NSDictionary *responseDic = [responseArray objectAtIndex:1];
            LWUserModel *model = [[LWUserManager shareInstance] getUserModel];
            model.dk = [responseDic objectForKey:@"dk"];
            model.ek = [responseDic objectForKey:@"ek"];
            [[LWUserManager shareInstance] setUser:model];
        }
    }
}

- (void)SRWebSocketDidColose:(NSNotification *)note{
    NSLog(@"wscolose");
}

- (void)manageSignInfo:(NSArray *)signArray{
    
//    if (!queue) {
//        queue = [[NSOperationQueue alloc] init];
//        queue.maxConcurrentOperationCount = 1;
//        signSemphore = dispatch_semaphore_create(0);
//    }
//
//    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
//               dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                   LWMultipySignTool *signTool = [[LWMultipySignTool alloc] initWithInitInfo:signArray];
//                   signTool.signBlock = ^(NSDictionary * _Nonnull sign) {
//                       dispatch_semaphore_signal(self->signSemphore);
//                   };
//                   dispatch_semaphore_wait(self->signSemphore, DISPATCH_TIME_FOREVER);
//               });
//
//    }];
//    [queue addOperation:operation];
//

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
}

- (void)manageMultipyWalletData:(NSDictionary *)personalData{
    [SVProgressHUD dismiss];
    
    [[NSUserDefaults standardUserDefaults] setObject:[personalData jsonStringEncoded] forKey:kMultipyWallet_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
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


@end
