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
@property (nonatomic, strong) NSString *pk;
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
+ (LWAddressTool *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWAddressTool alloc]init];
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

- (instancetype)initWithRid:(NSString *)rid{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    params = @{@"threshold":@(1),@"share_count":@(PARTIES)};
    
    self.party_count = 3;
    self.party_index = 1;
    self.party_num_int = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCast:) name:kWebScoket_boardcast object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheKey:) name:kWebScoket_getTheKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmAddress:) name:kWebScoket_confirmAddress object:nil];

    
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    
    NSString *secret = [infoDic objectForKey:@"secret"];

    NSString *dpStr = [NSString stringWithFormat:@"%s",get_random_key_pair()];
    NSData * jsonData = [dpStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *pqArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    self.pk = [infoDic objectForKey:@"pk"];
    self.p = [pqArray firstObject];
    self.q = [pqArray lastObject];
    self.share_count = PARTIES;
   
    char *chartest =create_party_key([self.pk cStringUsingEncoding:NSASCIIStringEncoding], [self.p cStringUsingEncoding:NSASCIIStringEncoding], [self.q cStringUsingEncoding:NSASCIIStringEncoding], self.party_count);
    NSString *chartestString = [NSString stringWithFormat:@"%s",chartest];
    NSArray *encryptionKeyArray = [NSJSONSerialization JSONObjectWithData:[chartestString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    self.encryptionKey = encryptionKeyArray.firstObject;
    self.bc = encryptionKeyArray[1];
    self.decom = encryptionKeyArray.lastObject;
   
    //self.y 私钥推公钥
//    NSData *pubkeyData = [[CBSecp256k1 generatePublicKeyWithPrivateKey:[self.pk dataUsingEncoding:NSUTF8StringEncoding] compression:YES] copy];
//    self.pubkey = [pubkeyData dataToHexString];
    
    char *publicKey = get_public_key([self.pk cStringUsingEncoding:NSUTF8StringEncoding]);
    self.pubkey = [NSString stringWithFormat:@"%s",publicKey];

    char *public_point = get_public_point([self.pubkey cStringUsingEncoding:NSUTF8StringEncoding]);

    NSString *yString = [NSString stringWithFormat:@"%s",public_point];
    self.y = [NSJSONSerialization JSONObjectWithData:[yString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
}

- (void)testNewMethod:(NSString *)rid{
    self.rid = rid;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *keyArray = [NSMutableArray array];
        for (NSInteger i =1 ; i<=1; i++) {
            char *key_generate = create_key([self.pk cStringUsingEncoding:NSASCIIStringEncoding], self.party_num_int, self.party_count, 1, [self.p cStringUsingEncoding:NSASCIIStringEncoding], [self.q cStringUsingEncoding:NSASCIIStringEncoding]);
            NSArray *key_generate_array = [LWAddressTool charToObject:key_generate];
            [keyArray addObj:key_generate_array];
        }
        
        for (NSInteger i = 0; i<keyArray.count; i++) {
            NSArray *key_generate = keyArray[i];
            NSLog(@"broadCast1:begin");
             self->_semaphoreSignal = dispatch_semaphore_create(0);
             [self broadCast:1 data:key_generate[1]];
             dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
             NSLog(@"broadCast1:end");
        }
        
        NSMutableArray *secretsArray = [NSMutableArray array];
        for (NSInteger i = 0; i<keyArray.count; i++) {
            NSArray *key_generate = keyArray[i];
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
              [secretsArray addObj:secrets];
              
              //对let item of share_list
              for (NSInteger k = 0; k<share_list.count; k++) {
                  NSArray *item = share_list[k];
                  __block NSString *key;
                  
                  self->_sendp2pSignal = dispatch_semaphore_create(0);
                  [PubkeyManager encrptWithTheKey:secrets[k] andSecret_share:item[1] SuccessBlock:^(id  _Nonnull data) {
                      key = data;
                      dispatch_semaphore_signal(self->_sendp2pSignal);
                  } WithFailBlock:^(id  _Nonnull data) {
                      dispatch_semaphore_signal(self->_sendp2pSignal);
                      return ;
                        
                  }];
                  dispatch_semaphore_wait(self->_sendp2pSignal, DISPATCH_TIME_FOREVER);
                  
                  self->_semaphoreSignal = dispatch_semaphore_create(0);
                  [self sendp2p:[item[0] integerValue] round:2 data:key];
                  NSLog(@"sendp2p:item0:%@ \n key:%@",item[0],key);
                  dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
              }
              
              self->_semaphoreSignal = dispatch_semaphore_create(0);
              [self broadCast:3 data:vss];
              dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
        }
        
        NSString *shareRequest;
        NSArray *vssRequest;
        for (NSInteger i = 0; i<keyArray.count; i++) {
            
            self->_getKeySignal = dispatch_semaphore_create(0);
            NSArray *poll_for_p2p_Array = [self poll_for_p2p:2];
            dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
            
            NSArray *key = keyArray[i];
            
            NSMutableArray *poll_for_p2p_Array_decrypt = [NSMutableArray array];
            NSArray *secrets = [secretsArray objectAtIndex:i];
            
            //decrypt poll_for_p2p 返回的值
            for (NSInteger j = 0; j<poll_for_p2p_Array.count; j++) {
                self->_broadcastWithValSignal = dispatch_semaphore_create(0);
                [PubkeyManager decrptWithSecret:secrets[j] andSecret_share:poll_for_p2p_Array[j] SuccessBlock:^(id  _Nonnull data) {
                    NSString *decryptStr = (NSString *)data;
                    [poll_for_p2p_Array_decrypt addObj:decryptStr];
                    dispatch_semaphore_signal(self->_broadcastWithValSignal);
                 } WithFailBlock:^(id  _Nonnull data) {
                    dispatch_semaphore_signal(self->_broadcastWithValSignal);
                    return ;
                }];
              dispatch_semaphore_wait(self->_broadcastWithValSignal, DISPATCH_TIME_FOREVER);
            }
  
            self->_getKeySignal = dispatch_semaphore_create(0);
            NSArray *poll_for_broadCast3_array = [self poll_for_broadCast:3];
            dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
            
            NSString *key0 = key[0];
            NSString *poll_for_p2p_Array_decrypt_Json = [poll_for_p2p_Array_decrypt jsonStringEncoded];
            NSString *poll_for_broadCast_array_json = [poll_for_broadCast3_array jsonStringEncoded];

            NSLog(@"poll_for_p2p_Array_Count:%ld \n key:%@ \n poll_for_p2p_Array_decrypt:%@ \n poll_for_broadCast_array:%@",(long)poll_for_p2p_Array.count,key0,poll_for_p2p_Array_decrypt_Json,poll_for_broadCast_array_json);
            
            char *key_handle_round2_char = key_handle_round2([LWAddressTool stringToChar:key[0]],[LWAddressTool objectToChar:poll_for_p2p_Array_decrypt] ,[LWAddressTool objectToChar:poll_for_broadCast3_array]);
            NSLog(@"key_handle_round2_char_success");

            NSArray *key_handle_round2_array = [LWAddressTool charToObject:key_handle_round2_char];
            NSString *shared_keys = key_handle_round2_array.firstObject;
            NSDictionary *dlog_proof = key_handle_round2_array[1];
            NSArray *vss = key_handle_round2_array.lastObject;
            
            self->_semaphoreSignal = dispatch_semaphore_create(0);
            [self broadCast:4 data:dlog_proof];
            dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
            
            NSLog(@"shared_keys:%@",shared_keys);
            NSLog(@"vss:%@",vss);
            shareRequest = shared_keys;
            vssRequest = vss;
        }
        
        
        for (NSArray *key in keyArray) {
          
            self->_getKeySignal = dispatch_semaphore_create(0);
            NSArray *poll_for_broadCast_array = [self poll_for_broadCast:4];
            dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
            
            char *ret = key_handle_round3([LWAddressTool stringToChar:key[0]], [LWAddressTool objectToChar:poll_for_broadCast_array]);
            NSLog(@"ret:%s",ret);//返回ture成功 其他fail
            if ([[LWAddressTool charToString:ret] isEqualToString:@"true"]) {
                [self requestAddress:shareRequest andvss:vssRequest];
            }
        }
        
        for (NSArray *key in keyArray) {
            char *destroy_key_char =  destroy_key([LWAddressTool stringToChar:key[0]]);
            NSLog(@"destroy_key_char:%s",destroy_key_char);
        }
    });
}

- (void)requestAddress:(NSString *)shares andvss:(NSArray *)vss{
    NSDictionary *initdataDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    __block NSString *shares_encrypt;
    self->_semaphoreSignal = dispatch_semaphore_create(0);
    [PubkeyManager getDkWithSecret:[initdataDic objectForKey:@"secret"] andpJoin:shares SuccessBlock:^(id  _Nonnull data) {
        shares_encrypt = data;
        dispatch_semaphore_signal(self->_semaphoreSignal);
    } WithFailBlock:^(id  _Nonnull data) {
        
    }];
    dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
     
    NSDictionary *multipyparams = @{@"share":shares_encrypt,@"vss":[vss jsonStringEncoded],@"rid":self.rid};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryComfirmAddress),WS_Home_confirmAdress,[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    
}


- (void)setWithrid:(NSString *)rid{
    [self testNewMethod:rid];
    return;
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
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
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
    NSLog(@"broadcastNotificationSuccess");
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        dispatch_semaphore_signal(_semaphoreSignal);
    }
}

- (void)getTheKey:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    NSLog(@"getTheKeySuccess");
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
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
        
    }
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
