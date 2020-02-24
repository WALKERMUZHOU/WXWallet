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
    self.listView = [[LWHomeListView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
    NSString *requestStr = [NSString stringWithFormat:@"wss://api.laxo.io/?t=%@&sig=%@&uid=%@",message,sig,uid];
    
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:requestStr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidColose:) name:kWebSocketDidCloseNote object:nil];

}

- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    NSArray *requetCurrentPriceArray = @[@"req",@(WSRequestIdWalletQueryTokenPrice),@"wallet.tokenPrice",@""];
    [[SocketRocketUtility instance] sendData:[requetCurrentPriceArray mp_messagePack]];

    NSDictionary *params = @{@"type":@1};
    NSArray *requestPersonalWalletArray = @[@"req",@(WSRequestIdWalletQueryPersonalWallet),@"wallet.query",[params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];

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
            WSRequestId requestId = [[responseArray objectAtIndex:1] integerValue];
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
                default:
                    break;
            }
        }
    }
}

- (void)SRWebSocketDidColose:(NSNotification *)note{
    NSLog(@"wscolose");
}

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
