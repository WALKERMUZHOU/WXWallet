//
//  LWSignTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/6.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSignTool.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"

@interface LWSignTool (){
    id   getTheKeyData;
    dispatch_semaphore_t _semaphoreSignal;
    dispatch_semaphore_t _broadcastSignal;

    dispatch_semaphore_t _getKeySignal;
    
    NSInteger _PARTIES_Sign;
    NSInteger _THRESHOLD_Sign;
}
@property (nonatomic, strong) NSString  *hashStr;
@property (nonatomic, strong) NSString  *address;

@property (nonatomic, strong) NSString  *rid;
@property (nonatomic, strong) NSString  *pk;

@property (nonatomic, strong) NSArray   *vss;
@property (nonatomic, strong) NSString        *share_key;

@property (nonatomic, assign) NSInteger party_num_int;

///参与方数量，2（表示过程需要几个用户参与）
@property (nonatomic, assign) NSInteger party_count;
///表示各个参与方的序号，多人钱包服务器会返回这个index，个人钱包默认为1
@property (nonatomic, assign) NSInteger party_index;

@property (nonatomic, assign) NSInteger share_count;
@property (nonatomic, assign) NSInteger threshold;

@end

@implementation LWSignTool

static LWSignTool *instance = nil;
+ (LWSignTool *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWSignTool alloc]init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)setWithAddress:(NSString *)address andHash:(NSString *)hash{
    self.address = address;
    self.hashStr = hash;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestSignInfo];
    });
}

- (void)startGetSign{
    if (self->_semaphoreSignal) {
        dispatch_semaphore_signal(self->_semaphoreSignal);
    }
    if (self->_broadcastSignal) {
            dispatch_semaphore_signal(self->_broadcastSignal);
    }
    if (self->_getKeySignal) {
        dispatch_semaphore_signal(self->_getKeySignal);
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        char *secret_char = sha256([LWAddressTool stringToChar:self.pk]);
        
        NSString *pqStr = [LWEncryptTool decryptwithTheKey:[LWAddressTool charToString:secret_char] message:[[LWUserManager shareInstance] getUserModel].dk andHex:1];
        NSArray *pqArray = [pqStr componentsSeparatedByString:@","];
        
        NSString *p = pqArray.firstObject;
        NSString *q = pqArray.lastObject;
        
        NSString *ek = [[LWUserManager shareInstance] getUserModel].ek;
        
        LWTrusteeModel *model = [[LWTrusteeManager shareInstance] getFirstModel];
        NSString *ek2 = model.ek;
        NSInteger party_id = self.party_num_int;
        
        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:1 data:@"1"];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);
        self->_broadcastSignal = nil;
        
        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_broadCast_list_1 = [self poll_for_broadCast:1];;
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        self->_getKeySignal = nil;
        
        NSMutableArray *signers_vec = [NSMutableArray array];
        NSInteger j = 0;
        for (NSInteger i = 1; i<self.threshold + 2; i++) {
            if (i == self.party_num_int) {
                [signers_vec addObj:@(party_id - 1)];
            }else{
                [signers_vec addObj:@([poll_for_broadCast_list_1[j] integerValue] -1)];
                j = j + 1;
            }
        }
        
        NSString *logString = [NSString stringWithFormat:@"share_key:%@ \n party_num:%@ \n vss:%@ \n signer:%@ \n count:%@ \n threshold:%@ \n eks:%@ \n p:%@ \n q:%@ \n message_hash:%@ \n",self.share_key,@(self.party_num_int),self.vss,signers_vec,@(self.share_count),@(self.threshold),@[ek,ek2],p,q,self.hashStr];
        NSLog(@"%@",logString);
        
        char *ret_char = create_sign([LWAddressTool stringToChar:self.share_key], self.party_num_int, [LWAddressTool objectToChar:self.vss], [LWAddressTool objectToChar:signers_vec], self.share_count, self.threshold, [LWAddressTool objectToChar:@[ek,ek2]], [LWAddressTool stringToChar:p], [LWAddressTool stringToChar:q], [LWAddressTool stringToChar:self.hashStr]);
        
        NSArray *ret_array = [LWAddressTool charToObject:ret_char];
        NSString *signer_id = ret_array.firstObject;
        NSArray *signer_data = ret_array.lastObject;
        
        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:2 data:signer_data];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);
        self->_broadcastSignal = nil;

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_broadCast_list_2 = [self poll_for_broadCast:2];;
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        self->_getKeySignal = nil;

        char *sign_handle_round_1 = sign_handle_round([LWAddressTool stringToChar:signer_id], 1, [LWAddressTool objectToChar:poll_for_broadCast_list_2]);
        NSArray *sign_handle_round_1_array = [LWAddressTool charToObject:sign_handle_round_1];
        
        for (NSArray *item in sign_handle_round_1_array) {
            self->_broadcastSignal = dispatch_semaphore_create(0);
            NSInteger item0_array = [item[0] integerValue];
            [self sendp2p:item0_array round:3 data:item[1]];
            NSLog(@"sendp2p:item0:%@ \n data:%@",item[0],item[1]);
            dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);
            self->_broadcastSignal = nil;
        }
                
        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_p2p_Array = [self poll_for_p2p:3];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        self->_getKeySignal = nil;

        NSString *sign_handle_round_2_params = [NSString stringWithFormat:@"key:%@ \n round:2 \n data:%@",signer_id,poll_for_p2p_Array];
        NSLog(@"sign_handle_round_2:%@",sign_handle_round_2_params);
        
        char *sign_handle_round_2 = sign_handle_round([LWAddressTool stringToChar:signer_id], 2, [LWAddressTool objectToChar:poll_for_p2p_Array]);
        
        if (sign_handle_round_2 == nil) {
            destroy_sign([LWAddressTool stringToChar:signer_id]);
            [WMHUDUntil showMessageToWindow:@"error"];
            [SVProgressHUD dismiss];
            return ;
        }
        
        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:4 data:[LWAddressTool charToObject:sign_handle_round_2]];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);
        self->_broadcastSignal = nil;

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_broadCast_list_3 = [self poll_for_broadCast:4];;
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        self->_getKeySignal = nil;

        //返回值顺序修改@{s,r}
        char *sign_handle_round_3 = sign_handle_round([LWAddressTool stringToChar:signer_id], 3, [LWAddressTool objectToChar:poll_for_broadCast_list_3]);
        NSArray *sign_handle_round_3_array = [LWAddressTool charToObject:sign_handle_round_3];

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_broadCast_list_5 = [self poll_for_broadCast:5];;
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        self->_getKeySignal = nil;

        NSMutableArray *signArray = [NSMutableArray array];
        [signArray addObj:sign_handle_round_3_array[0]];
        for (NSInteger i = 0; i<poll_for_broadCast_list_5.count; i++) {
            NSArray *array = [poll_for_broadCast_list_5 objectAtIndex:i];
            [signArray addObj:array[0]];
        }
                
        char *sign = sum_scalar([LWAddressTool objectToChar:signArray]);
        
        NSLog(@"sign:%@",[LWAddressTool charToString:sign]);
        
        NSMutableArray *sum_point_array = [NSMutableArray array];
        for (NSInteger i = 0; i<self.vss.count; i++) {
            NSArray *vssArray = [self.vss objectAtIndex:i];
            NSString *vssFirstStr = vssArray.firstObject;
            [sum_point_array addObj:vssFirstStr];
        }
        char *sum_point_char = get_group_pubkey([LWAddressTool objectToChar:sum_point_array]);

        
        
        if (self.signBlock) {
            self.signBlock(@{@"r":sign_handle_round_3_array[1],@"sign":[LWAddressTool charToString:sign],@"pubkey":[LWAddressTool charToString:sum_point_char]});
        }
        destroy_sign([LWAddressTool stringToChar:signer_id]);
        
    });
    
}


- (void)initData{
    _PARTIES_Sign = 2;
    _THRESHOLD_Sign = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSig:) name:kWebScoket_requestPartySign object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getkeyshare:) name:kWebScoket_getkeyshare object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCast:) name:kWebScoket_boardcast object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheKey:) name:kWebScoket_getTheKey object:nil];

    self.party_num_int = 1;
    self.share_count = _PARTIES_Sign;
    self.threshold = 1;
    self.party_count = 2;
    self.party_index = 1;
}

- (void)requestSignInfo{//wallet.requestPartySign
    self.pk = [LWPublicManager getPKWithZhuJiCi];
    char *sig_char = get_message_sig([LWAddressTool stringToChar:self.hashStr], [LWAddressTool stringToChar:self.pk]);
    NSString *sig = [LWAddressTool charToString:sig_char];
    NSDictionary *multipyparams = @{@"hash":self.hashStr,@"address":self.address,@"sig":sig};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryrequestPartySign),@"wallet.requestPartySign",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)requestShare{
    NSDictionary *params = @{@"address":self.address};
    NSArray *requestPersonalWalletArray = @[@"req",
                                             @(WSRequestIdWalletQueryGetKeyShare),
                                             WS_Home_getKeyShare,
                                             [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}


- (void)broadCast:(NSInteger)round data:(id)valArray{
    NSString *key = [NSString stringWithFormat:@"%ld_%ld",(long)self.party_index,(long)round];
    NSDictionary *multipyparams = @{@"id":self.rid,@"key":key,@"val":valArray};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBoardCast),@"message.set",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)sendp2p:(NSInteger)to round:(NSInteger)round data:(id)data{
    NSArray *array = @[@(self.party_index),@(round),@(to)];
    NSString *key = [array componentsJoinedByString:@"_"];
    NSDictionary *multipyparams = @{@"id":self.rid,@"key":key,@"val":data};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBoardCast),@"message.set",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];

}

- (NSArray *)poll_for_broadCast:(NSInteger)round{
    NSInteger n = self.party_count;
    NSInteger party_index = self.party_index;

    NSMutableArray *list = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSInteger i = 1; i< n+1; i++) {
            if (i != party_index) {
                self->_semaphoreSignal = dispatch_semaphore_create(0);
                NSString *key = [@[@(i),@(round)] componentsJoinedByString:@"_"];

                dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(timer, ^{
                    [self getKey:key];
                });
                dispatch_resume(timer);
                
                dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
                [list addObj:self->getTheKeyData];
                dispatch_cancel(timer);
            }
        }
        dispatch_semaphore_signal(self->_getKeySignal);
    });
    
    return list;
}

- (NSArray *)poll_for_p2p:(NSInteger)round{
    NSInteger n = self.party_count;
    NSInteger party_index = self.party_index;
    NSMutableArray *list = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->_semaphoreSignal = dispatch_semaphore_create(0);
        for (NSInteger i = 1; i< n+1; i++) {
            if (i != self.party_index) {
                NSString *key = [@[@(i),@(round),@(party_index)] componentsJoinedByString:@"_"];
                
                dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(timer, ^{
                    NSLog(@"poll_for_p2p");
                    [self getKey:key];
                });
                dispatch_resume(timer);
                
                dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
                NSLog(@"wait");
                [list addObj:self->getTheKeyData];
                dispatch_cancel(timer);
            }
        }
        dispatch_semaphore_signal(self->_getKeySignal);
        NSLog(@"signal");

    });

    return list;
}


- (void)getKey:(NSString *)key{
    NSDictionary *multipyparams = @{@"id":self.rid,@"key":key};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryGetTheKey),@"message.get",[multipyparams jsonStringEncoded]];
    NSLog(@"requestmultipyWalletArray:%@",requestmultipyWalletArray);
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}


#pragma mark - method
- (void)getSig:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSDictionary *dataDic = [notiDic objectForKey:@"data"];

        self.rid = [dataDic objectForKey:@"rid"];
        NSString *vssStr = [dataDic objectForKey:@"vss"];
        self.vss = [NSJSONSerialization JSONObjectWithData:[vssStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [self requestShare];
    }
}

- (void)getkeyshare:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSArray *keysArray = [notiDic objectForKey:@"data"];
        NSDictionary *keyDic = keysArray.firstObject;
        NSString *shareKey = [keyDic objectForKey:@"share"];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            char *secret_char = sha256([LWAddressTool stringToChar:self.pk]);
            self.share_key = [LWEncryptTool decryptwithTheKey:[LWAddressTool charToString:secret_char] message:shareKey andHex:1];
            
            [self startGetSign];
        });
        

    }
    /*
     data =         (
                     {
             address = 1Hz3cTY2zxDRSh9rgZmFUoNC8qGJKE3Raw;
             createtime = 1583470608000;
             id = 38;
             share = 4c050fea9f7166c9e4a2443385ff760cf9f6bfb8b4f29f036569d54670c0f003ecc14317662a521e7155c03804e720f7fad3bdc2d965044ac63a0d30185b01f03084352ca36a189e6f8da125a99c6b6f;
             uid = 1005;
         }
     );
     */
}


- (void)boardCast:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    NSLog(@"broadcastNotificationSuccess");
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_semaphore_signal(self->_broadcastSignal);
        });
        NSLog(@"signal");
    }
}

- (void)getTheKey:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    NSLog(@"getTheKeySuccess");
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        id getTheKeyDataID = [notiDic objectForKey:@"data"];
        if ([getTheKeyData isEqual:getTheKeyDataID]) {
            return;
        }
        getTheKeyData = [notiDic objectForKey:@"data"];
        
        dispatch_semaphore_signal(self->_semaphoreSignal);
        NSLog(@"signal");
    }
}

@end
