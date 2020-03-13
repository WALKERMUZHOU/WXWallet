//
//  LWMultipySignTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/12.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyAdressTool.h"

#import "libthresholdsig.h"
#import "LWAddressTool.h"

@interface LWMultipyAdressTool (){
    id   getTheKeyData;
    dispatch_semaphore_t _semaphoreSignal;
    dispatch_semaphore_t _broadcastSignal;

    dispatch_semaphore_t _getKeySignal;
    dispatch_semaphore_t _sendp2pSignal;
    dispatch_semaphore_t _broadcastWithValSignal;

    dispatch_semaphore_t _mainThreadSignal;
}

@property (nonatomic, assign) NSInteger share_count;
@property (nonatomic, assign) NSInteger party_count;
@property (nonatomic, assign) NSInteger party_index;

@property (nonatomic, assign) NSInteger threshold;

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSArray *vss;

@end

@implementation LWMultipyAdressTool

- (instancetype)initWithInitInfo:(NSArray *)info{
    self = [super init];
    if (self) {
        [self initDataWithInfo:info];
    }
    return self;
}

- (void)initDataWithInfo:(NSArray *)info{//[id,wid,share,threshold,index(不需要),users,dericePth（通过path计算pk）]
    self.rid = [info firstObject];
    self.threshold = [[info objectAtIndex:3] integerValue];
    self.share_count = [[info objectAtIndex:2] integerValue];

    if (self.threshold %2 == 0) {
        self.threshold ++;
        self.share_count ++;
    }
    
    self.party_count = self.share_count;
    NSArray *userArray = info[5];
    for (NSInteger i = 0; i<userArray.count; i++) {
        NSString *userId = [NSString stringWithFormat:@"%@", [userArray objectAtIndex:i]];
        LWUserModel  *user = [[LWUserManager shareInstance] getUserModel];
        if ([user.uid isEqualToString:userId]) {
            self.party_index = (i+1);
        }
    }
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSig:) name:kWebScoket_requestPartySign object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getkeyshare:) name:kWebScoket_getkeyshare object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCast:) name:kWebScoket_boardcast object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheKey:) name:kWebScoket_getTheKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmAddress:) name:kWebScoket_confirmAddress object:nil];
    [self managedata:info[6]];
}

- (void)managedata:(NSString *)path{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *pk = [LWPublicManager getPKWithZhuJiCiAndPath:path];

        char *create_multi_key_char = create_multi_key(self.party_index, [LWAddressTool stringToChar:pk], self.share_count, self.threshold);
        
        NSDictionary *key = [self KeyGenWithIndex:self.party_index count:self.share_count data:[LWAddressTool charToObject:create_multi_key_char]];

        NSMutableArray *list = [NSMutableArray array];
        for (NSInteger i = 1; i<self.share_count + 1; i++) {
            if (self.party_index != i) {
                [list addObj:@(i)];
            }
        }

        
        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:1 data:[key objectForKey:@"data"]];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_data = [self poll_for_broadCast:1];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);

        NSString *keyStr = [key objectForKey:@"id"];
        char *handleRound_1 = multi_key_handle_round([LWAddressTool stringToChar:keyStr], 1, [LWAddressTool objectToChar:poll_data]);

        NSDictionary *handelRount_1_dic = [LWAddressTool charToObject:handleRound_1];
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        
        NSMutableArray *handelRount_secret = [NSMutableArray array];
        NSMutableArray *handelRount_key = [NSMutableArray array];
        NSMutableDictionary *handelSecretDic = [NSMutableDictionary dictionary];

        for (NSInteger i = 0; i<handelRount_1_dic.allKeys.count; i++) {
            NSString *key_round1 = handelRount_1_dic.allKeys[i];
            NSArray *handelRount_1_dic_value = [handelRount_1_dic objectForKey:key_round1];
               
           NSString *handelRount_1_first = [handelRount_1_dic_value firstObject];
           NSString *handelRount_1_last = [handelRount_1_dic_value lastObject];
           
           [handelRount_secret addObj:handelRount_1_first];
           [handelRount_key addObj:key_round1];
           [handelSecretDic setObject:handelRount_1_first forKey:key_round1];

           NSString *encrypt = [LWEncryptTool encrywithTheKey:handelRount_1_first message:handelRount_1_last andHex:1];
           [dd setObj:encrypt forKey:key_round1];
        }
        
//        for (NSString *key_round1 in handelRount_1_dic.allKeys) {
//
//            NSArray *handelRount_1_dic_value = [handelRount_1_dic objectForKey:key_round1];
//
//            NSString *handelRount_1_first = [handelRount_1_dic_value firstObject];
//            NSString *handelRount_1_last = [handelRount_1_dic_value lastObject];
//
//            [handelRount_secret addObj:handelRount_1_first];
//            [handelRount_key addObj:key_round1];
//            [handelSecretDic setObject:handelRount_1_first forKey:key_round1];
//
//            NSString *encrypt = [LWEncryptTool encrywithTheKey:handelRount_1_first message:handelRount_1_last andHex:1];
//            [dd setObj:encrypt forKey:key_round1];
//        }

        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:2 data:dd];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_broadcasts_2 = [self poll_for_broadCast:2];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        
        NSMutableArray *pollForBroadcasts_2_manage_array = [NSMutableArray array];
        
        for (NSInteger i = 0; i<poll_for_broadcasts_2.count; i++) {
            NSMutableDictionary *pollForBroadcasts_2_itemDic = [NSMutableDictionary dictionary];

            NSDictionary *poll_for_broadcasts_2_dic = poll_for_broadcasts_2[i];
            for (NSInteger j = 0; j<poll_for_broadcasts_2_dic.allKeys.count; j++) {
                NSString *key_t =[poll_for_broadcasts_2_dic.allKeys objectAtIndex:j];
                if (key_t.integerValue == self.party_index) {
                    
                    NSString *secretSSS = [handelSecretDic objectForKey:[NSString stringWithFormat:@"%@",[list objectAtIndex:i]]];
            
                    NSString *needDecrtptStr = [poll_for_broadcasts_2_dic objectForKey:poll_for_broadcasts_2_dic.allKeys[j]];
                    NSString *decrtptStr = [LWEncryptTool decryptwithTheKey:secretSSS message:needDecrtptStr andHex:1];
                    [pollForBroadcasts_2_itemDic setObj:decrtptStr forKey:poll_for_broadcasts_2_dic.allKeys[j]];
                }
            }
            [pollForBroadcasts_2_manage_array addObj:pollForBroadcasts_2_itemDic];
        }
        
        NSLog(@"%@",pollForBroadcasts_2_manage_array);
        
        char *handeRound_2 = multi_key_handle_round([LWAddressTool stringToChar:keyStr], 2, [LWAddressTool objectToChar:pollForBroadcasts_2_manage_array]);
         
        NSArray *handleRound_2_array = [LWAddressTool charToObject:handeRound_2];
        self.vss = handleRound_2_array.lastObject;

        char *secret_char = sha256([LWAddressTool stringToChar:[LWPublicManager getPKWithZhuJiCi]]);
        
        NSString *shares_encrypt = [LWEncryptTool encrywithTheKey:[LWAddressTool charToString:secret_char] message:handleRound_2_array.firstObject andHex:1];
        
        NSString *shareStr = handleRound_2_array.firstObject;
        
        destroy_multi_key([LWAddressTool stringToChar:keyStr]);
        
        //1.share 转publickey
        char *pubkey = get_public_key([LWAddressTool stringToChar:shareStr]);
        NSLog(@"%s",pubkey);
        NSString *checkPubkey = [LWAddressTool charToString:pubkey];

        NSInteger flag = 0;
        for (NSArray *array in self.vss){
            for (NSString *stringpub in array) {
                if ([stringpub isEqualToString:checkPubkey]) {
                    flag = 1;
                    break;
                }
            }
        }
        if (flag == 0) {
            NSLog(@"地址生成error");
            return ;
        }

        
        NSDictionary *multipyparams = @{@"share":shares_encrypt,@"vss":[self.vss jsonStringEncoded],@"rid":self.rid};
        NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryComfirmAddress),WS_Home_multipyConfirmAdress,[multipyparams jsonStringEncoded]];
        [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    });
}

- (NSDictionary *)KeyGenWithIndex:(NSInteger)index  count:(NSInteger) count data:(NSArray *)data{
    id data_data = data[1];
    id data_id = data.firstObject;
    return @{@"index":@(index),@"party_count":@(count),@"data":data_data,@"id":data_id};
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
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
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
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
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
- (void)confirmAddress:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    NSLog(@"confirmAddress");
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
            NSString *address = [notiDic objectForKey:@"data"];
            if (self.addressBlock) {
                self.addressBlock(address);
            }
        }
    }
}


- (void)getSig:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSDictionary *dataDic = [notiDic objectForKey:@"data"];

//        self.rid = [dataDic objectForKey:@"rid"];
//        NSString *vssStr = [dataDic objectForKey:@"vss"];
//        self.vss = [NSJSONSerialization JSONObjectWithData:[vssStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//        [self requestShare];
    }
}

- (void)getkeyshare:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSArray *keysArray = [notiDic objectForKey:@"data"];
        NSDictionary *keyDic = keysArray.firstObject;
        NSString *shareKey = [keyDic objectForKey:@"share"];

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            char *secret_char = sha256([LWAddressTool stringToChar:self.pk]);
//            self.share_key = [LWEncryptTool decryptwithTheKey:[LWAddressTool charToString:secret_char] message:shareKey andHex:1];
//            [self startGetSign];
        });
    }
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
        getTheKeyData = [notiDic objectForKey:@"data"];
        dispatch_semaphore_signal(self->_semaphoreSignal);
        NSLog(@"signal");
    }
}

@end
