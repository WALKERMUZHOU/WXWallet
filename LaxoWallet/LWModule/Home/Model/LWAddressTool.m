//
//  LWAddressTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/2.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWAddressTool.h"
//#import "rust.h"
//#import "EncryptUtil.h"
//#import "BTCData.h"
//#import "CBSecp256k1.h"
//#import "NSData+Hashing.h"
//#import "NSData+HexString.h"

//#import "NS+BTCBase58.h"

#import "libthresholdsig.h"


@interface LWAddressTool (){
    dispatch_semaphore_t _semaphoreSignal;
    id   getTheKeyData;
    dispatch_semaphore_t _getKeySignal;
    dispatch_semaphore_t _sendp2pSignal;
    dispatch_semaphore_t _broadcastWithValSignal;

    dispatch_semaphore_t _mainThreadSignal;
    NSDictionary *params;

}

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) NSString *pk;//计算地址时使用
@property (nonatomic, strong) NSString *prikey;//用户自己pk
@property (nonatomic, strong) NSString *pubkey;
@property (nonatomic, strong) NSString *p;
@property (nonatomic, strong) NSString *q;
@property (nonatomic, strong) NSString *address;

///参与方数量，用户，后台，遨游
@property (nonatomic, assign) NSInteger party_count;
///表示各个参与方的序号，多人钱包服务器会返回这个index，个人钱包默认为1
@property (nonatomic, assign) NSInteger party_index;

@property (nonatomic, assign) NSInteger party_num_int;

@property (nonatomic, assign) NSInteger share_count;

@property (nonatomic, strong) NSString *encryptionKey;
@property (nonatomic, strong) NSDictionary *bc;
@property (nonatomic, strong) NSDictionary *decom;
@property (nonatomic, strong) NSDictionary *y;

@end
NSInteger PARTIES = 3;

@implementation LWAddressTool

static LWAddressTool *instance = nil;
static dispatch_once_t onceToken;
+ (LWAddressTool *)shareInstance{
    dispatch_once(&onceToken, ^{
        instance = [[LWAddressTool alloc]init];
    });
    return instance;
}

- (void)initData{
    params = @{@"threshold":@(1),@"share_count":@(PARTIES)};
    
    self.party_count = 3;
    self.party_index = 1;
    self.party_num_int = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCast:) name:kWebScoket_boardcast object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheKey:) name:kWebScoket_getTheKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmAddress:) name:kWebScoket_confirmAddress object:nil];

    NSString *seed = [[LWUserManager shareInstance] getUserModel].jiZhuCi;

    char *derive_key_char = derive_key([LWAddressTool stringToChar:seed], [LWAddressTool stringToChar:self.path]);
    self.pk = [LWAddressTool charToString:derive_key_char];
    
    self.pk = [LWPublicManager getPKWithZhuJiCiAndPath:self.path];
    
    self.prikey = [LWPublicManager getPKWithZhuJiCi];
   
    char *secret_char = sha256([LWAddressTool stringToChar:self.prikey]);

    NSString *pqStr = [LWEncryptTool decryptwithTheKey:[LWAddressTool charToString:secret_char] message:[[LWUserManager shareInstance] getUserModel].dk andHex:1];
    NSArray *pqArray = [pqStr componentsSeparatedByString:@","];
    
    self.p = [pqArray firstObject];
    self.q = [pqArray lastObject];
    self.share_count = PARTIES;
        
}

- (void)setWithrid:(NSString *)rid andPath:(nonnull NSString *)path{
    self.rid = rid;
    self.path = path;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self initData];

            char *key_generate_char = create_key([self.pk cStringUsingEncoding:NSASCIIStringEncoding], self.party_num_int, self.party_count, 1, [self.p cStringUsingEncoding:NSASCIIStringEncoding], [self.q cStringUsingEncoding:NSASCIIStringEncoding]);
            NSArray *key_generate_array = [LWAddressTool charToObject:key_generate_char];
        
            NSArray *key_generate = key_generate_array;
            NSLog(@"broadCast1:begin");
             self->_semaphoreSignal = dispatch_semaphore_create(0);
             [self broadCast:1 data:key_generate[1]];
             dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
             NSLog(@"broadCast1:end");
        
        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_broadCast_list_1 = [self poll_for_broadCast:1];;
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
              
        char *key_handle_round1_char = key_handle_round1([LWAddressTool stringToChar:key_generate[0]], [LWAddressTool objectToChar:poll_for_broadCast_list_1]);
        NSArray *key_handle_round1_array = [LWAddressTool charToObject:key_handle_round1_char];
        NSArray *share_list = key_handle_round1_array.firstObject;
        NSArray *vss = key_handle_round1_array.lastObject;
              
        //获取secret
        NSInteger j = 0;
        NSMutableArray *secrets = [NSMutableArray array];
        for (NSInteger i = 1; i<PARTIES+1; i++) {
            if (i == self.party_num_int) {

            }else{
                NSArray *list = poll_for_broadCast_list_1[j];
                NSString *firstObject_Str = list.firstObject;
                const char *firstObject_char = [firstObject_Str cStringUsingEncoding:NSUTF8StringEncoding];
                char *get_shared_secret_char = get_shared_secret([self.pk cStringUsingEncoding:NSUTF8StringEncoding], firstObject_char);
                [secrets addObj:[NSString stringWithFormat:@"%s",get_shared_secret_char]];
                NSLog(@"self.pk:%@ \n y_i:%@ \n result:%@",self.pk,firstObject_Str,[NSString stringWithFormat:@"%s",get_shared_secret_char]);
                j++;
            }
        }
              
        //对let item of share_list
        for (NSInteger k = 0; k<share_list.count; k++) {
            NSArray *item = share_list[k];
            NSString *keytemp = [LWEncryptTool encrywithKey_tss:secrets[k] message:item[1]];

            self->_semaphoreSignal = dispatch_semaphore_create(0);
            [self sendp2p:[item[0] integerValue] round:2 data:keytemp];
            NSLog(@"sendp2p:item0:%@ \n key:%@",item[0],keytemp);
            dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
        }

        self->_semaphoreSignal = dispatch_semaphore_create(0);
        [self broadCast:3 data:vss];
        dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);

        
        NSString *shareRequest;
        NSArray *vssRequest;
            
        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_p2p_Array = [self poll_for_p2p:2];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
                    
        NSMutableArray *poll_for_p2p_Array_decrypt = [NSMutableArray array];
        
        //decrypt poll_for_p2p 返回的值
        
        for (NSInteger j = 0; j<poll_for_p2p_Array.count; j++) {
            NSString *decryptStr_temp = [LWEncryptTool decryptwithKey_tss:secrets[j] message:poll_for_p2p_Array[j] andHex:1];
            [poll_for_p2p_Array_decrypt addObj:decryptStr_temp];
        }

        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_broadCast3_array = [self poll_for_broadCast:3];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        
        NSString *key0 = key_generate_array[0];
        NSString *poll_for_p2p_Array_decrypt_Json = [poll_for_p2p_Array_decrypt jsonStringEncoded];
        NSString *poll_for_broadCast_array_json = [poll_for_broadCast3_array jsonStringEncoded];

        NSLog(@"poll_for_p2p_Array_Count:%ld \n key:%@ \n poll_for_p2p_Array_decrypt:%@ \n poll_for_broadCast_array:%@",(long)poll_for_p2p_Array.count,key0,poll_for_p2p_Array_decrypt_Json,poll_for_broadCast_array_json);
        
        char *key_handle_round2_char = key_handle_round2([LWAddressTool stringToChar:key_generate_array[0]],[LWAddressTool objectToChar:poll_for_p2p_Array_decrypt] ,[LWAddressTool objectToChar:poll_for_broadCast3_array]);
        NSLog(@"key_handle_round2_char_success");

        NSArray *key_handle_round2_array = [LWAddressTool charToObject:key_handle_round2_char];
        if (!key_handle_round2_array || key_handle_round2_array.count ==0) {
            [WMHUDUntil showMessageToWindow:@"error"];
            return ;
        }
        NSString *shared_keys = key_handle_round2_array.firstObject;
        NSDictionary *dlog_proof = key_handle_round2_array[1];
        NSArray *vss_2 = key_handle_round2_array.lastObject;
        
        self->_semaphoreSignal = dispatch_semaphore_create(0);
        [self broadCast:4 data:dlog_proof];
        dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
        
        NSLog(@"shared_keys:%@",shared_keys);
        NSLog(@"vss:%@",vss_2);
        shareRequest = shared_keys;
        vssRequest = vss_2;
        
        
        
          
        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *poll_for_broadCast_array = [self poll_for_broadCast:4];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        
        char *ret = key_handle_round3([LWAddressTool stringToChar:key_generate_array[0]], [LWAddressTool objectToChar:poll_for_broadCast_array]);
        NSLog(@"ret:%s",ret);//返回ture成功 其他fail
        if ([[LWAddressTool charToString:ret] isEqualToString:@"true"]) {
            [self requestAddress:shareRequest andvss:vssRequest];
        }
        
        char *destroy_key_char =  destroy_key([LWAddressTool stringToChar:key_generate_array[0]]);
        NSLog(@"destroy_key_char:%s",destroy_key_char);
    });
}

- (void)requestAddress:(NSString *)shares andvss:(NSArray *)vss{
    
    char *secret_char = sha256([LWAddressTool stringToChar:self.prikey]);

    NSString *shares_encrypt = [LWEncryptTool encrywithTheKey:[LWAddressTool charToString:secret_char] message:shares andHex:1];
    
     
    NSDictionary *multipyparams = @{@"share":shares_encrypt,@"vss":[vss jsonStringEncoded],@"rid":self.rid};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryComfirmAddress),WS_Home_confirmAdress,[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    
}


- (void)broadCast:(NSInteger)round data:(id)valArray{
    NSString *key = [NSString stringWithFormat:@"%ld_%ld",(long)self.party_index,(long)round];
    NSDictionary *multipyparams = @{@"id":self.rid,@"key":key,@"val":valArray};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBoardCast),@"message.set",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)broadCast2:(NSArray *)valArray{
    
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
        self->_semaphoreSignal = dispatch_semaphore_create(0);
        for (NSInteger i = 1; i< n+1; i++) {
            if (i != party_index) {
                NSString *key = [@[@(i),@(round)] componentsJoinedByString:@"_"];
                NSLog(@"getkeystart");
                dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(timer, ^{
                    [self getKey:key];
                });
                dispatch_resume(timer);
                
                dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
                NSLog(@"getkeyend");
                [list addObj:self->getTheKeyData];
                dispatch_cancel(timer);
            }
        }
        NSLog(@"listEnd0");
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
                [list addObj:self->getTheKeyData];
                dispatch_cancel(timer);
            }
        }
        dispatch_semaphore_signal(self->_getKeySignal);
    });

    return list;
}

- (void)getKey:(NSString *)key{
    NSDictionary *multipyparams = @{@"id":self.rid,@"key":key};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryGetTheKey),@"message.get",[multipyparams jsonStringEncoded]];
    NSLog(@"requestmultipyWalletArray:%@",requestmultipyWalletArray);
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)boardCast:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    NSLog(@"broadcast:%@",notiDic);
    NSLog(@"broadcastNotificationSuccess");
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        dispatch_semaphore_signal(_semaphoreSignal);
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
        dispatch_semaphore_signal(_semaphoreSignal);
    }
}

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
        
    }else{
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:@"Get Address Error"];
        return;
    }
}

+ (void)attempDealloc{
   onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
   instance = nil;
}


+ (NSString *)charToString:(char *)sChar{
    NSString *string = [NSString stringWithFormat:@"%s",sChar];
    return string;
}

+ (char *)stringToChar:(NSString *)cString{
    return [cString cStringUsingEncoding:NSASCIIStringEncoding];
}

+ (char *)objectToChar:(id)sObject{
    return [[sObject jsonStringEncoded] cStringUsingEncoding:NSASCIIStringEncoding];
}

+ (id)charToObject:(char *)sChar{

    return [NSJSONSerialization JSONObjectWithData:[[NSString stringWithFormat:@"%s",sChar] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}
@end
