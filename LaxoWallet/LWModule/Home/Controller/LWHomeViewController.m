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
    
    [PubkeyManager getPrikeyByZhujiciSuccessBlock:^(id  _Nonnull data) {
        NSString *prikey = [data objectForKey:@"prikey"];
        [self getSignWithPriKey:prikey];
    } WithFailBlock:^(id  _Nonnull data) {
        
    }];
}

- (void)getSignWithPriKey:(NSString *)prikey{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)a]; //转为字符型
    
    [PubkeyManager getSigWithPK:prikey message:timeString SuccessBlock:^(id  _Nonnull data) {
        NSString *sig = (NSString *)data;
        [self startWebScoket:sig andmessage:timeString];
    } WithFailBlock:^(id  _Nonnull data) {
        
    }];
}

- (void)startWebScoket:(NSString *)sig andmessage:(NSString *)message{
    NSString *uid = [[LWUserManager shareInstance] getUserModel].login_token;
//    NSString *requestStr = [NSString stringWithFormat:@"wss://api.laxo.io/?t=%@&sig=%@&uid=%@",message,sig,uid];
    NSString *requestStr = [NSString stringWithFormat:@"ws://192.168.0.106:7001/?t=%@&sig=%@&uid=%@",message,sig,uid];

    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:requestStr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidColose:) name:kWebSocketDidCloseNote object:nil];

}

- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
//    NSArray *requetCurrentPriceArray = @[@"req",@(WSRequestIdWalletQueryTokenPrice),@"wallet.tokenPrice",@""];
//    [[SocketRocketUtility instance] sendData:[requetCurrentPriceArray mp_messagePack]];

    NSDictionary *params = @{@"type":@1};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestIdWalletQueryPersonalWallet),
                                            @"wallet.query",
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SocketRocketUtility instance] sendData:data];
    });

    [self requestMulipyWalletInfo];
}

- (void)requestMulipyWalletInfo{
    NSDictionary *multipyparams = @{@"type":@2};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
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
             [self managePersonalWalletData:responseArray[2]];
             break;
         case WSRequestIdWalletQueryMulpityWallet:
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
               [SVProgressHUD dismiss];
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
