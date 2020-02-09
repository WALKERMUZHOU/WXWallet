//
//  LWNetWorkSessionManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWNetWorkSessionManager.h"
static NSTimeInterval const kTimeoutIntervalDefault = 30.0;

@interface LWNetWorkSessionManager () {
    BOOL _hasConnecteNetWork;
}

@property (nonatomic ,strong) AFNetworkReachabilityManager *networkReachabilityManager;

@end
@implementation LWNetWorkSessionManager
+ ( LWNetWorkSessionManager *)shareInstance{
    
    static  LWNetWorkSessionManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[ LWNetWorkSessionManager alloc] initWithURL:[NSURL URLWithString:kBaseAddress]];
    });
    return _shareInstance;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
//        AFSecurityPolicy *securityPolicy = [self customSecurityPolicy];
//        self.securityPolicy = securityPolicy;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
//        [self setAccessTokenForHeader];
//        if ([[CQMDevice obtainDevice] deviceId]) {
//            [self.requestSerializer setValue:[[CQMDevice obtainDevice] deviceId] forHTTPHeaderField:@"deviceId"];
//        }
//        [self.requestSerializer setValue:@"0" forHTTPHeaderField:@"platform"];
//        [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"channel"];
//        [self.requestSerializer setValue:kAppSource forHTTPHeaderField:@"source"];
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        [self.requestSerializer setValue:app_Version forHTTPHeaderField:@"appVersion"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",                                                                     @"application/octet-stream",nil];
        
        _hasConnecteNetWork = YES;
        
        // 设置默认超时时间
        [self.requestSerializer setTimeoutInterval:kTimeoutIntervalDefault];
    }
    return self;
}

- (void)clearAccessTokenForHeader {
    [self.requestSerializer setValue:@"" forHTTPHeaderField:@"accessToken"];
}


- (void)resetDeviceIdForHeader{
    [self.requestSerializer setValue:@"" forHTTPHeaderField:@"deviceId"];

}

//- (void)setGTClientId{
//    if (!([self.requestSerializer.HTTPRequestHeaders objectForKey:@"clientId"].length > 0)) {
//        if ([CQMDevice obtainDevice].deviceId.length > 0) {
//            [self.requestSerializer setValue:[[CQMUser shareInstance] getGTClientId] forHTTPHeaderField:@"clientId"];
//        }
//    }
//}

//对接https
- (AFSecurityPolicy *)customSecurityPolicy
{
    /**** SSL Pinning ****/
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"miaomiaodai" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //  自签名证书设为YES 生产X.509证书设置为NO
    [securityPolicy setAllowInvalidCertificates:YES];
    NSSet *cerSet = [NSSet setWithObjects:certData, nil];
    [securityPolicy setPinnedCertificates:cerSet];
    /**** SSL Pinning ****/
    
    return securityPolicy;
}

- (NSURLSessionDataTask *)getPath:(NSString *)path parameters:(NSDictionary *)parameters withBlock:(void (^)(NSDictionary *, NSError *))block{
    return [self getPath:path parameters:parameters noAccesstoken:NO withBlock:block];
}

- (NSURLSessionDataTask *)getPath:(NSString *)path parameters:(NSDictionary *)parameters noAccesstoken:(BOOL)isNoAccesstoken withBlock:(void (^)(NSDictionary *, NSError *))block{
    NSDictionary *processDictionary = [self getProcessedParameter:parameters];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kBaseAddress, path];
    
    return [self GET:urlStr parameters:processDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            result = (NSDictionary *)responseObject;
        }else if([responseObject isKindOfClass:[NSData class]]){
            NSData *_data = responseObject;
            id _json = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
            result = [NSDictionary dictionaryWithDictionary:_json];
        }
        
        if (block) {
             block(result,nil);
         }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}

- (NSURLSessionDataTask *)postPath:(NSString *)path parameters:(NSDictionary *)parameters withBlock:(void (^)(NSDictionary *, NSError *))block{
    return [self postPath:path parameters:parameters noAccesstoken:NO withBlock:block];

}

- (NSURLSessionDataTask *)postPath:(NSString *)path parameters:(NSDictionary *)parameters noAccesstoken:(BOOL)isNoAccesstoken withBlock:(void (^)(NSDictionary *, NSError *))block{

    NSDictionary *processDictionary = [self getProcessedParameter:parameters];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kBaseAddress, path];

    return [self POST:urlStr parameters:processDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            result = (NSDictionary *)responseObject;
        }else if([responseObject isKindOfClass:[NSData class]]){
            NSData *_data = responseObject;
            id _json = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
            result = [NSDictionary dictionaryWithDictionary:_json];
        }
        
        if (block) {
            block(result,nil);
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block([NSDictionary dictionary],error);
        }
    }];
}

//添加所有接口的公共参数，对安全性验证
- (NSDictionary *)getProcessedParameter:(NSDictionary *)process{
    NSMutableDictionary *beforeProcess;
    if (process) {
        beforeProcess = [[NSMutableDictionary alloc]initWithDictionary:process];
    }else {
        beforeProcess = [[NSMutableDictionary alloc]init];
    }
//    CQMUser *user = [CQMUser shareInstance];
//    if ([user getUserInfo]) {
//        [beforeProcess setValue:[user getToken] forKey:@"accessToken"];
//    }
//
//    if ([CQMDevice obtainDevice]) {
//        [beforeProcess setValue:[[CQMDevice obtainDevice] deviceId] forKey:@"deviceId"];
//    }
//    [beforeProcess addEntriesFromDictionary:@{@"platform":@"0",
//                                              @"appVersion":[[UIDevice currentDevice] systemVersion],
//                                              }];

    return beforeProcess;
}

- (void)dealloc {
    [self stopMonitoring];
}

#pragma mark - 网络状态
- (BOOL)netWorkAbility {
    return _hasConnecteNetWork;
}
// 开始检测网络状态
- (void)startMonitoring {
    [self.networkReachabilityManager startMonitoring];
}
// 停止检测网络状态
- (void)stopMonitoring {
    [self.networkReachabilityManager stopMonitoring];
}

#pragma mark - lazy
- (AFNetworkReachabilityManager *)networkReachabilityManager {
    if (nil == _networkReachabilityManager) {
        _networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
        
        [_networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未知网络");
                    _hasConnecteNetWork = NO;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"无法联网");
                    _hasConnecteNetWork = NO;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"当前使用的是2g/3g/4g网络");
                    _hasConnecteNetWork = YES;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"当前在WIFI网络下");
                    _hasConnecteNetWork = YES;
                    break;
                default:
                    break;
            }
        }];
    }
    return _networkReachabilityManager;
}

#pragma mark - 设置超时
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
    
    [self.requestSerializer setTimeoutInterval:timeoutInterval];
}
@end
