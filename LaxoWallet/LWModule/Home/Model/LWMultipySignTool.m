//
//  LWSignTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/6.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipySignTool.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"

@interface LWMultipySignTool (){
    id   getTheKeyData;
    dispatch_semaphore_t _semaphoreSignal;
    dispatch_semaphore_t _broadcastSignal;

    dispatch_semaphore_t _getKeySignal;
    dispatch_semaphore_t _sendp2pSignal;
    dispatch_semaphore_t _broadcastWithValSignal;

    dispatch_semaphore_t _mainThreadSignal;
    
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

@property (nonatomic, assign) NSInteger party_orginal;

///参与方数量，2（表示过程需要几个用户参与）
@property (nonatomic, assign) NSInteger party_count;
///表示各个参与方的序号，多人钱包服务器会返回这个index，个人钱包默认为1
@property (nonatomic, assign) NSInteger party_index;

@property (nonatomic, assign) NSInteger share_count;
@property (nonatomic, assign) NSInteger threshold;

@property (nonatomic, strong) NSString  *hash_str;

@property (nonatomic, strong) NSArray  *info;

@property (nonatomic, assign) NSInteger  broadcastId;
@property (nonatomic, assign) NSInteger  pollbroadcatsId;
@property (nonatomic, assign) NSInteger  submitSigId;



@end

@implementation LWMultipySignTool

//static LWMultipySignTool *instance = nil;
//+ (LWMultipySignTool *)shareInstance{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[LWMultipySignTool alloc]init];
//    });
//    return instance;
//}

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithInitInfo:(NSArray *)info{
    self = [super init];
    if (self) {
        [self initDataWithInfo:info];
    }
    return self;
}

- (void)initDataWithInfo:(NSArray *)info{//[id,hash,threshold,share,singers,key,part_ordinal,pubkey）]
//    info = @[
//        @"854b8b3da05bf7f1",
//        @"df6b164911b2ff127512136ba28652d5148887dd6e8b5219c497646a4cd64457",
//        @(2),
//        @(2),
//        @[@(1),@(2),@(3)],
//        @"065CD0AB6B8BB5D3AB30E854BF132A6A874446546EE3B89D7BF41350DE8678FE3D1FA9017F411F16B2D346F863E4390C492FC84469A3D39642E48D0BEB9F376004755C35D8B046D696359CA944995F4E",
//       @(2)
//    ];
    
    NSInteger broadcastAppend = arc4random();
    NSInteger pollBroadcastAppend = arc4random();
    NSInteger submitSigAppend = arc4random();
    
    self.broadcastId = [NSString stringWithFormat:@"30000%ld",(long)broadcastAppend].integerValue;
    self.pollbroadcatsId = [NSString stringWithFormat:@"31000%ld",(long)pollBroadcastAppend].integerValue;
    self.submitSigId = [NSString stringWithFormat:@"32000%ld",(long)submitSigAppend].integerValue;
    
    self.info = info;
    self.rid = [info firstObject];
    self.threshold = [[info objectAtIndex:2] integerValue];
    self.share_count = [[info objectAtIndex:3] integerValue];
    self.party_orginal = [[info objectAtIndex:6] integerValue];
    if (self.threshold %2 == 0) {
        self.threshold = self.threshold + 1;
        self.share_count = self.share_count + 1;
    }
    self.party_count = self.share_count;
    
    self.pk = [LWPublicManager getPKWithZhuJiCi];
    
    NSArray *signers_list = [info objectAtIndex:4];
    for (NSInteger i = 0; i<signers_list.count; i++) {
        NSInteger singersCount = [[signers_list objectAtIndex:i] integerValue];
        if (singersCount == self.party_orginal) {
            self.party_index = (i+1);
        }
    }
    
    self.hash_str =  [info objectAtIndex:1];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSig:) name:kWebScoket_requestPartySign object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCast:) name:kWebScoket_MultipyBroadcast_sig object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheKey:) name:kWebScoket_MultipyPollBroadcast_sig object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitSigNoti:) name:kWebScoket_multipySubmitSig object:nil];

    [self managedata:info];
}

- (void)managedata:(NSArray *)info{////[id,hash,threshold,share,singers,key,part_ordinal,publicKey ）]

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *sigUserlist = [NSMutableArray arrayWithArray:[info objectAtIndex:4]];
        for (NSInteger i = 0; i< sigUserlist.count; i++) {
            NSInteger abc = [[sigUserlist objectAtIndex:i] integerValue];
            if (abc == self.party_orginal) {
                [sigUserlist removeObjectAtIndex:i];
                break;
            }
        }
        
        NSArray *signers_list = [info objectAtIndex:4];
        NSString *key_share = [info objectAtIndex:5];

        char *secret_char = sha256([LWAddressTool stringToChar:self.pk]);

        self.share_key = [LWEncryptTool decryptwithTheKey:[LWAddressTool charToString:secret_char] message:key_share andHex:1];
        
        char *create_multi_sign_char = create_multi_sign([LWAddressTool stringToChar:self.share_key], self.party_orginal, [LWAddressTool objectToChar:signers_list], self.threshold, [LWAddressTool stringToChar:self.hash_str]);
        
        NSDictionary *singer = [self KeyGenWithIndex:self.party_orginal count:signers_list.count data:[LWAddressTool charToObject:create_multi_sign_char]];
        
        NSString *singerStr = [singer objectForKey:@"id"];

        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:1 data:[singer objectForKey:@"data"]];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *sig_poll_for_broadcasts_1 = [self poll_for_broadCast:1];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        
        char *ret = multi_sign_handle_round([LWAddressTool stringToChar:singerStr], 1, [LWAddressTool objectToChar:sig_poll_for_broadcasts_1]);
        NSDictionary *retDic = [LWAddressTool charToObject:ret];
        NSMutableDictionary *k_evals = [NSMutableDictionary dictionary];
        NSMutableDictionary *alpha_evals = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *secretMap = [NSMutableDictionary dictionary];
        
        NSMutableArray *secretArray = [NSMutableArray array];
        for (NSString *retKey in retDic.allKeys) {
            NSArray *retArray = [retDic objectForKey:retKey];
            NSString *secret = retArray.firstObject;
            NSString *k = retArray[1];
            NSString *alpha = retArray.lastObject;
            [secretArray addObj:secret];
            
            NSString *kencrypt = [LWEncryptTool encrywithTheKey:secret message:k andHex:1];
            [k_evals setObj:kencrypt forKey:retKey];
            
            NSString *alphaEncrypt = [LWEncryptTool encrywithTheKey:secret message:alpha andHex:1];
            [alpha_evals setObj:alphaEncrypt forKey:retKey];
            
            [secretMap setObject:secret forKey:retKey];
        }

        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:2 data:@[k_evals,alpha_evals]];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *sig_poll_for_broadcasts_2 = [self poll_for_broadCast:2];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        
        NSMutableArray *broadcasts_2_array = [NSMutableArray array];
        for (NSInteger i = 0; i<sig_poll_for_broadcasts_2.count; i++) {
            
            NSMutableArray *kAArray = [NSMutableArray array];
            NSArray *sig_poll_for_broadcasts_2_i = sig_poll_for_broadcasts_2[i];
            
            NSDictionary *kDic = sig_poll_for_broadcasts_2_i[0];
            NSString *needDecrtptStr = [kDic objectForKey:[NSString stringWithFormat:@"%ld",(long)self.party_orginal]];
            NSString *secretSSS = [secretMap objectForKey:[NSString stringWithFormat:@"%@",[sigUserlist objectAtIndex:i]]];
            NSString *decrtptStr = [LWEncryptTool decryptwithTheKey:secretSSS message:needDecrtptStr andHex:1];
            [kAArray addObj:@{[NSString stringWithFormat:@"%ld",(long)self.party_orginal]:decrtptStr}];
            
            NSDictionary *alphaDic = sig_poll_for_broadcasts_2_i[1];
            NSString *needDecrtptStr_A = [alphaDic objectForKey:[NSString stringWithFormat:@"%ld",(long)self.party_orginal]];
            NSString *secretSSS_A = [secretMap objectForKey:[NSString stringWithFormat:@"%@",[sigUserlist objectAtIndex:i]]];
            NSString *decrtptStr_A = [LWEncryptTool decryptwithTheKey:secretSSS_A message:needDecrtptStr_A andHex:1];
            [kAArray addObj:@{[NSString stringWithFormat:@"%ld",(long)self.party_orginal]:decrtptStr_A}];
             
            [broadcasts_2_array addObj:kAArray];
        }
        NSLog(@"%@",broadcasts_2_array);
        
        char *multi_sign_handle_round_2 = multi_sign_handle_round([LWAddressTool stringToChar:singerStr], 2, [LWAddressTool objectToChar:broadcasts_2_array]);
        NSArray *multi_sign_handle_round_2_array = [LWAddressTool charToObject:multi_sign_handle_round_2];

        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:3 data:multi_sign_handle_round_2_array];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *sig_poll_for_broadcasts_3 = [self poll_for_broadCast:3];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);

        id sig_r;
        id sig_s;
        char *multi_sign_handle_round_3 = multi_sign_handle_round([LWAddressTool stringToChar:singerStr], 3, [LWAddressTool objectToChar:sig_poll_for_broadcasts_3]);
        NSArray *multi_sign_handle_round_3_array = [LWAddressTool charToObject:multi_sign_handle_round_3];

        sig_r = multi_sign_handle_round_3_array.firstObject;

        self->_broadcastSignal = dispatch_semaphore_create(0);
        [self broadCast:4 data:multi_sign_handle_round_3_array.lastObject];
        dispatch_semaphore_wait(self->_broadcastSignal, DISPATCH_TIME_FOREVER);

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *sig_poll_for_broadcasts_4 = [self poll_for_broadCast:4];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);

        char *multi_sign_handle_round_4 = multi_sign_handle_round([LWAddressTool stringToChar:singerStr], 4, [LWAddressTool objectToChar:sig_poll_for_broadcasts_4]);

        sig_s = [LWAddressTool charToString:multi_sign_handle_round_4];
        
        char *verifySig = verify_sig([LWAddressTool stringToChar:self.hash_str], [LWAddressTool stringToChar:self.info[7]], [LWAddressTool stringToChar:sig_r], multi_sign_handle_round_4);
        if ([[LWAddressTool charToString:verifySig] isEqualToString:@"true"]) {
            [self submitSig:@{@"r":sig_r,@"s":sig_s}];
        }
        
        destroy_multi_sign([LWAddressTool stringToChar:singerStr]);
    });
    

}

- (NSDictionary *)KeyGenWithIndex:(NSInteger)index count:(NSInteger) count data:(NSArray *)data{
    id data_data = data[1];
    id data_id = data.firstObject;
    return @{@"index":@(index),@"party_count":@(count),@"data":data_data,@"id":data_id};
}

#pragma mark - netrequest

- (void)submitSig:(NSDictionary *)sigDic{
    NSDictionary *params = @{@"rid":self.rid,@"sig":[sigDic jsonStringEncoded]};
    NSArray *requestPersonalWalletArray = @[@"req",
                                             @(self.submitSigId),
                                             WS_Home_multipySubmitSig,
                                             [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

#pragma mark - net_response
- (void)broadCast:(NSInteger)round data:(id)valArray{
    NSString *key = [NSString stringWithFormat:@"%ld_%ld",(long)self.party_index,(long)round];
    NSDictionary *multipyparams = @{@"id":self.rid,@"key":key,@"val":valArray};
    NSArray *requestmultipyWalletArray = @[@"req",@(self.broadcastId),@"message.set",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)sendp2p:(NSInteger)to round:(NSInteger)round data:(id)data{
    NSArray *array = @[@(self.party_index),@(round),@(to)];
    NSString *key = [array componentsJoinedByString:@"_"];
    NSDictionary *multipyparams = @{@"id":self.rid,@"key":key,@"val":data};
    NSArray *requestmultipyWalletArray = @[@"req",@(self.broadcastId),@"message.set",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (NSArray *)poll_for_broadCast:(NSInteger)round{
    NSInteger n = self.party_count;
    NSInteger party_index = self.party_index;

    NSMutableArray *list = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->_semaphoreSignal = dispatch_semaphore_create(0);
        for (NSInteger i = 1; i< n+1; i++) {
            if (i != party_index) {
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
    NSArray *requestmultipyWalletArray = @[@"req",@(self.pollbroadcatsId),@"message.get",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    NSLog(@"pollBroadcast：%@",multipyparams);
}


#pragma mark - method
- (void)boardCast:(NSNotification *)notification{
    NSArray *notiArray = notification.object;
    if ([notiArray[1] integerValue] == self.broadcastId) {
        NSDictionary *notiDic = notiArray[2];
        NSLog(@"broadcastNotificationSuccess");
        if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
            NSLog(@"pollbroadcatsId:%@,%@",notiArray[1],@(self.broadcastId));

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_semaphore_signal(self->_broadcastSignal);
            });
            NSLog(@"signal");
        }
    }else{
        NSLog(@"return duplic boardCast");
    }
}

- (void)getTheKey:(NSNotification *)notification{
    NSArray *notiArray = notification.object;
    if ([notiArray[1] integerValue] == self.pollbroadcatsId) {
        NSDictionary *notiDic = notiArray[2];
        NSLog(@"pollbroadcatsId:%@,%@",notiArray[1],@(self.pollbroadcatsId));

        if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
            
            id getTheKeyDataID = [notiDic objectForKey:@"data"];
            if ([getTheKeyData isEqual:getTheKeyDataID]) {
                return;
            }
            getTheKeyData = [notiDic objectForKey:@"data"];
            dispatch_semaphore_signal(self->_semaphoreSignal);
            NSLog(@"signal");
        }
    }else{
        NSLog(@"return duplic pollbroadcatsId");
    }
}

- (void)submitSigNoti:(NSNotification *)notification{
    NSArray *notiArray = notification.object;
    if ([notiArray[1] integerValue] == self.submitSigId) {
        NSDictionary *notiDic = notiArray[2];
        NSLog(@"submitSigId:%@,%@",notiArray[1],@(self.submitSigId));
        
        NSLog(@"submitSigSuccess");
        if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
            if (self.signBlock) {
                self.signBlock([notiDic objectForKey:@"data"]);
            }
        }

    }else{
        NSLog(@"return duplic sign");
    }
}
@end
