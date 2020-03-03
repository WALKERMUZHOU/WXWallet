//
//  LWAddressTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/2.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWAddressTool.h"
#import "rust.h"
#import "EncryptUtil.h"
#import "BTCData.h"
#import "CBSecp256k1.h"
#import "NSData+Hashing.h"
#import "NSData+HexString.h"

#import "NS+BTCBase58.h"

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
@property (nonatomic, strong) NSString *y;

@end
NSInteger PARTIES = 2;

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
    NSData *pubkeyData = [[CBSecp256k1 generatePublicKeyWithPrivateKey:[self.pk dataUsingEncoding:NSUTF8StringEncoding] compression:YES] copy];
    self.y = [pubkeyData dataToHexString];

}

- (void)setWithrid:(NSString *)rid{
    self.rid = rid;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->_semaphoreSignal = dispatch_semaphore_create(0);
        [self broadCast:1 data:@[self.y,self.bc,self.decom]];
        NSLog(@"begin");
        dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
        
        NSLog(@"listStart");
        self->_getKeySignal = dispatch_semaphore_create(0);
        NSArray *list = [self poll_for_broadCast:1];
        dispatch_semaphore_wait(self->_getKeySignal, DISPATCH_TIME_FOREVER);
        NSLog(@"listEnd");
        
        NSMutableArray *bc1_vec = [NSMutableArray array];
        NSMutableArray *y_vec = [NSMutableArray array];
        NSMutableArray *decom_vec = [NSMutableArray array];
        NSInteger j = 0;
        for (NSInteger i = 1; i<PARTIES+1; i++) {
            if (i == self.party_num_int) {
                [bc1_vec addObj:self.bc];
                [y_vec addObj:self.y];
                [decom_vec addObj:self.decom];
            }else{
                NSArray *listArray = list[j];
                [y_vec addObj:listArray.firstObject];
                [bc1_vec addObj:listArray[1]];
                [decom_vec addObj:listArray.lastObject];
            }
        }
        
        NSMutableArray *paillier_key_vec = [NSMutableArray array];
        for (NSInteger i = 0; i<bc1_vec.count; i++) {
            NSDictionary *bc1Dic = bc1_vec[i];
            [paillier_key_vec addObj:[bc1Dic objectForKey:@"e"]];
        }
            
        NSString *str = [NSString stringWithFormat:@"%ld",self.party_num_int];
//            uint8_t buff_str[1024];
//            memcpy(buff_str,[str UTF8String], [str length]+1);
//            NSLog(@"char = %s",buff_str);
        uint8_t buff_str = self.party_num_int;

        NSData * someData = [str dataUsingEncoding:NSUTF8StringEncoding];
        const void * bytes = [someData bytes];
        int length = [someData length];
        
        //简单方法
        uint8_t *crypto_data = (uint8_t *)bytes;
        const char *pkchar = [self.pk cStringUsingEncoding:NSASCIIStringEncoding];
        const char *paramsChar = [[self->params jsonStringEncoded] cStringUsingEncoding:NSASCIIStringEncoding];
        const char *decom_vecChar =  [[decom_vec jsonStringEncoded] cStringUsingEncoding:NSASCIIStringEncoding];
        const char *bc1_vecChar =  [[bc1_vec jsonStringEncoded] cStringUsingEncoding:NSASCIIStringEncoding];
        
        char *ret = get_party_shares( pkchar, self.party_num_int ,paramsChar,decom_vecChar,bc1_vecChar);
        NSString *retString = [NSString stringWithFormat:@"%s",ret];
        NSData *retData = [retString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *retArray = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *vss_scheme = retArray.firstObject;
        NSArray *secret_shares = retArray.lastObject;
        
        //message.sendp2p(i, '2', key.toString('hex'));
        //message.sendp2p(i,'r3', secret_shares[k]);

        NSLog(@"sendp2pStart");
        NSInteger k = 0;
        self->_semaphoreSignal = dispatch_semaphore_create(0);
        for (NSInteger i = 1; i < PARTIES + 1; i++) {
            if (i != self.party_num_int) {
                [self sendp2p:i round:2 data:secret_shares[k]];
                dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
                NSLog(@"sendp2pEnd:%ld",(long)i);
             }
             k = k + 1;
        }

        NSLog(@"broadCast3Start");
        self->_semaphoreSignal = dispatch_semaphore_create(0);
        [self broadCast:3 data:vss_scheme];
        dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
        
        
        NSLog(@"broadCast3End");
        
        //message.broadcast('3', vss_scheme);
        //message.broadcast('r4', vss_scheme);
    });
    
    




}


- (void)broadCast:(NSInteger)round data:(NSArray *)valArray{
    NSString *key = [NSString stringWithFormat:@"%ld_%ld",(long)self.party_index,(long)round];
    
    NSDictionary *multipyparams = @{@"id":self.rid,@"key":key,@"val":valArray};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBoardCast),@"message.set",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)broadCast2:(NSArray *)valArray{
    
}

- (void)sendp2p:(NSInteger)to round:(NSInteger)round data:(NSDictionary *)data{
    NSArray *array = @[@(self.party_index),@(round),@(to)];
    NSString *key = [array componentsJoinedByString:@"_"];
    NSDictionary *multipyparams = @{@"key":key,@"val":data};
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
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
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
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(timer, ^{
                    [self getKey:key];
                });
                dispatch_resume(timer);
                
                dispatch_semaphore_wait(self->_semaphoreSignal, DISPATCH_TIME_FOREVER);
                //dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
                [list addObj:self->getTheKeyData];
                dispatch_suspend(timer);
            }
        }
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


/*
 {
     com =     (
         3528824510,
         603956902,
         589075108,
         2963738765,
         525367573,
         1853214318,
         1707963038,
         366464193
     );
     "correct_key_proof" =     {
         "sigma_vec" =         (
                         (
                 3460130240,
                 2501600720,
                 1773825436,
                 2036903931,
                 3325584890,
                 116882507,
                 1909248554,
                 734086345,
                 1130339631,
                 29268299,
                 3991108946,
                 1730238608,
                 3542302784,
                 1375838038,
                 1415018159,
                 2177305789,
                 473359189,
                 2863209714,
                 1857841349,
                 1323191412,
                 308221423,
                 2939320644,
                 4007811868,
                 3840199578,
                 3935122729,
                 440014592,
                 699908277,
                 2591579004,
                 1100775159,
                 2853450734,
                 3233025981,
                 14462619
             ),
                         (
                 711443236,
                 2084560396,
                 1365777211,
                 803549540,
                 972399636,
                 3493482462,
                 4152251021,
                 2616631288,
                 1651056664,
                 3750055416,
                 235827582,
                 3549613942,
                 2929334627,
                 4143334423,
                 2471064660,
                 1677724683,
                 3396409739,
                 2342088286,
                 522207940,
                 1565301232,
                 3571142758,
                 3688988980,
                 3483386097,
                 3842076240,
                 2261121928,
                 1312503411,
                 1190215456,
                 997092430,
                 1902328763,
                 3129611729,
                 3516593205,
                 379447674
             ),
                         (
                 3034597454,
                 156277143,
                 3112219118,
                 302540509,
                 137437728,
                 3215252278,
                 3609202779,
                 370972781,
                 2757107613,
                 2327597797,
                 1647491635,
                 1870390545,
                 649367287,
                 3785667978,
                 987733660,
                 1899116988,
                 2043750608,
                 131915708,
                 2876831461,
                 3876824280,
                 2678814768,
                 1268590266,
                 345758434,
                 1393337293,
                 1105071037,
                 118572011,
                 1250299059,
                 3520772822,
                 587039855,
                 577824573,
                 4041002293,
                 314413365
             ),
                         (
                 3747807024,
                 3802202765,
                 3286457140,
                 2074558281,
                 2596660703,
                 375723139,
                 1563266007,
                 3983905616,
                 3493279431,
                 4224980548,
                 841051359,
                 954390254,
                 1641507595,
                 3324552682,
                 3153819955,
                 2083851888,
                 1267283818,
                 3782065766,
                 3670004455,
                 3248341003,
                 3159059129,
                 3021927332,
                 2869404712,
                 1816615936,
                 2499101081,
                 2246909958,
                 155320142,
                 1841914417,
                 1068177893,
                 1901895004,
                 2837383696,
                 18487225
             ),
                         (
                 4076897399,
                 2130292077,
                 2295705912,
                 3719408018,
                 1660803939,
                 3076715465,
                 1663060578,
                 3197866296,
                 1084874051,
                 173733046,
                 2268657868,
                 1117165817,
                 1958392676,
                 3849409202,
                 1733596735,
                 1778018541,
                 2102234465,
                 3618303516,
                 2569356024,
                 4204241438,
                 3184139255,
                 660898013,
                 595149260,
                 4030553327,
                 1485573928,
                 3462511486,
                 3043580505,
                 1623898882,
                 625888450,
                 875536391,
                 4100859764,
                 281071757
             ),
                         (
                 3780769580,
                 364354105,
                 1323138155,
                 1925037239,
                 1749554564,
                 393310134,
                 1819339041,
                 141661124,
                 245279858,
                 2673302186,
                 353803607,
                 1787412069,
                 62870951,
                 1948454323,
                 3230230245,
                 1532302986,
                 629311875,
                 3523688135,
                 186382619,
                 4092630822,
                 3741496191,
                 2937647228,
                 1956834554,
                 3487585086,
                 3186935104,
                 2922800771,
                 1057499706,
                 3937410020,
                 3504273690,
                 1378579334,
                 620344203,
                 334313445
             ),
                         (
                 3443253863,
                 2066883022,
                 1038004666,
                 3450358261,
                 1568080931,
                 3717399551,
                 1516207424,
                 1878717878,
                 3448307795,
                 509439449,
                 1504756014,
                 3709990030,
                 3785124402,
                 3530861957,
                 3485080255,
                 3436538441,
                 501988291,
                 443500116,
                 2202255532,
                 1813871392,
                 2448588997,
                 2374611560,
                 3969302807,
                 1101042620,
                 2538939916,
                 2887633560,
                 3599145732,
                 942342729,
                 463504574,
                 3736446579,
                 2297726773,
                 424453510
             ),
                         (
                 1281330841,
                 822817952,
                 2825240578,
                 1170646558,
                 395846175,
                 47714021,
                 2229172244,
                 35833107,
                 3478885852,
                 1768746205,
                 1022936454,
                 524132681,
                 543683753,
                 1368813995,
                 2582456153,
                 3749676709,
                 443426090,
                 1963692255,
                 2435754306,
                 1339223438,
                 595180701,
                 709909771,
                 2871732361,
                 566751094,
                 886442094,
                 1413433254,
                 1084781122,
                 1541397652,
                 70660115,
                 3252395750,
                 440355185,
                 256616502
             ),
                         (
                 1045233996,
                 1170161971,
                 2998702561,
                 356579199,
                 1096153741,
                 796563645,
                 614162629,
                 4049904917,
                 1710125622,
                 2580710375,
                 2960733570,
                 1225216528,
                 361086245,
                 2983628647,
                 1345814296,
                 989049532,
                 598080954,
                 1060251066,
                 1833749460,
                 777617077,
                 3487887224,
                 3689433883,
                 1662974627,
                 2182332185,
                 3272468557,
                 3279874655,
                 2699413314,
                 1012741323,
                 2850592095,
                 3238381075,
                 1959125157,
                 138192273
             ),
                         (
                 3733432332,
                 1733961261,
                 3530083918,
                 4135884348,
                 1043891290,
                 3578100628,
                 2863162315,
                 2876911216,
                 4153562010,
                 1368107448,
                 58298907,
                 940976449,
                 3989951768,
                 2671768414,
                 554584058,
                 3442304150,
                 2170954432,
                 1586969887,
                 523990714,
                 2834752598,
                 1999971301,
                 1837168398,
                 966374229,
                 4082283724,
                 3655004266,
                 3252852141,
                 1678702769,
                 947315908,
                 1733379111,
                 873315452,
                 3193803437,
                 227326729
             ),
                         (
                 766856919,
                 3585525729,
                 1707432246,
                 546215170,
                 647239217,
                 430071092,
                 2093945475,
                 3589997267,
                 2843616994,
                 1759084722,
                 1794778518,
                 2107126535,
                 2621330388,
                 4006305921,
                 2326842677,
                 2723791117,
                 877768789,
                 3541136482,
                 1242509863,
                 1150974959,
                 1505197897,
                 238058252,
                 3135102315,
                 4272980538,
                 694651005,
                 2697889951,
                 1559960937,
                 4259018617,
                 4128290072,
                 1574888734,
                 1234433283,
                 52666680
             )
         );
     };
     e =     {
         n =         (
             3637509649,
             735604617,
             2453951612,
             3472163843,
             4089943438,
             1930498867,
             303538895,
             2659459263,
             4258557140,
             418703775,
             2586711429,
             2308275528,
             2157234023,
             2209625816,
             1101582487,
             3898837704,
             724508721,
             3922746148,
             4057231830,
             4011743069,
             1369221502,
             3807532040,
             2298521324,
             3299567649,
             1680908608,
             3987818036,
             749777026,
             2660459761,
             1265779762,
             1545122153,
             1656910181,
             435564723
         );
     };
 },
 */
@end
