//
//  LWBaseCoordinator.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseCoordinator.h"

typedef void (^name_t)(NSString *name, NSString *paramers);

@implementation LWBaseCoordinatorRequestItem

@end

@interface LWBaseCoordinator()

@property (nonatomic, copy) name_t  nameBlock;
@property (nonatomic, assign) NSInteger  index;

@end

@implementation LWBaseCoordinator

+ (void)logoutAction {
//    [[LWNetworkSessionManager shareInstance] clearAccessTokenForHeader];
}

- (void)setLoadedAllData:(BOOL)loadedAllData {
    [self.currentRequestItem setLoadedAllData:loadedAllData];
    if (loadedAllData && self.delegate && [self.delegate respondsToSelector:@selector(coordinatorLoadedAllData)]) {
        [self.delegate coordinatorLoadedAllData];
    }
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showErrorMessage = YES;
        self.requestItemArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<LWCoordinatorDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.requestItemArray = [NSMutableArray array];
        self.showErrorMessage = YES;
    }
    return self;
}

#pragma mark - Methods

- (void)getCurrentRequestItem:(NSString *)path andParamers:(NSDictionary *)paramers{
    if (!path) {
        return;
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithDictionary:paramers];
    [dataDic setObject:path forKey:@"path"];
//    NSString *jsonString = [JsonUtil dictionaryToJson:dataDic];
    
}

- (void)getCurrentRequestItem:(NSString *)path {
    if (!path) {
        return;
    }
    LWBaseCoordinatorRequestItem *currentRequestItem;
    for (LWBaseCoordinatorRequestItem *requestItem in self.requestItemArray) {
        if ([requestItem.path isEqualToString:path]) {
            currentRequestItem = requestItem;
            break;
        }
    }
    if (!currentRequestItem) {
        currentRequestItem = [[LWBaseCoordinatorRequestItem alloc] init];
        currentRequestItem.path = path;
        [self.requestItemArray addObject:currentRequestItem];
    }
    self.currentRequestItem = currentRequestItem;
}

- (void)loadDataWithPath:(NSString *)path {
    [self setSmsToken:nil];
    [self loadDataWithPath:path parameters:nil requestSerializer:RequestSerializerTypeJson type:NSNotFound success:nil];
}

- (void)loadDataWithPath:(NSString *)path type:(NSInteger)type {
    [self setSmsToken:nil];
    [self loadDataWithPath:path parameters:nil requestSerializer:RequestSerializerTypeJson type:type success:nil];
}

- (void)loadDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    [self setSmsToken:nil];
    [self loadDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:NSNotFound success:nil];
}

- (void)loadDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters noAccesstoken:(BOOL)isNoAccesstoken{
    [self setSmsToken:nil];
    [self loadDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:NSNotFound noAccesstoken:isNoAccesstoken success:nil];
}

- (void)loadDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters requestSerializer:(RequestSerializerType)serializerType{
    [self setSmsToken:nil];
    [self loadDataWithPath:path parameters:parameters requestSerializer:serializerType type:NSNotFound success:nil];
}

- (void)loadDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters type:(NSInteger)type {
    [self setSmsToken:nil];
    [self loadDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:type success:nil];
}

- (void)loadDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(BOOL success))block  {
    [self setSmsToken:nil];
    [self loadDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:NSNotFound success:block];
}

- (void)loadDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters requestSerializer:(RequestSerializerType )serializerType type:(NSInteger)type success:(void (^)(BOOL success))block {
    [self setSmsToken:nil];
    [self loadDataWithPath:path parameters:parameters requestSerializer:serializerType type:type noAccesstoken:NO success:block];
}

- (void)loadDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters noAccesstoken:(BOOL)isNoAccesstoken andSmsToken:(NSString *)smsToken{
    [self setSmsToken:smsToken];
    [self loadDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:NSNotFound noAccesstoken:isNoAccesstoken success:nil];
}

- (void)loadDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters requestSerializer:(RequestSerializerType )serializerType type:(NSInteger)type noAccesstoken:(BOOL)isNoAccesstoken success:(void (^)(BOOL success))block {
    
//    if (![[LWNetworkSessionManager shareInstance].requestSerializer.HTTPRequestHeaders objectForKey:@"deviceId"]
//        || !([[LWNetworkSessionManager shareInstance].requestSerializer.HTTPRequestHeaders objectForKey:@"deviceId"].length > 0)) {
//        [LWDevice storeDeviceWithComplete:^{
//            [[LWNetworkSessionManager shareInstance] setDeviceIdForHeader];
//
//            [self loadDataWithPath:path parameters:parameters requestSerializer:serializerType type:type noAccesstoken:isNoAccesstoken success:block];
//        }];
//
//        return;
//    }
//
//    [self getCurrentRequestItem:path];
//    self.currentRequestItem.type = type;
//    if ([path isEqualToString:self.currentRequestItem.path] && self.currentRequestItem.requesting) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(coordinatorRepeatRequestFail)]) {
//            [self.delegate coordinatorRepeatRequestFail];
//        }
//        return;
//    }
//    if ([self.delegate respondsToSelector:@selector(coordinatorBegainRequest)]) {
//        self.currentRequestItem.requesting = YES;
//        [self.delegate coordinatorBegainRequest];
//    }
//    [self resetBeginningState:parameters];
//    __weak typeof(self) weakSelf = self;
//    self.nameBlock = ^(NSString *name, NSString *paramers) {
//        if([name isEqualToString:@"success"]){
//            [weakSelf loadDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:NSNotFound noAccesstoken:isNoAccesstoken success:block];
//        }else if ([name isEqualToString:@"smsToken"]){
//            [weakSelf loadDataWithPath:path parameters:parameters noAccesstoken:isNoAccesstoken andSmsToken:paramers];
//        }else{
//            UIAlertController *alertControl = [UIAlertController  alertControllerWithTitle:nil message:@"登录信息过期,请重新登录" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [SystemUtil logoutDeviceWithNOAction];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [[NSNotificationCenter defaultCenter]postNotificationName:KUserAccountLogIn object:nil];
//                    [LogicHandle popToCurrentRootViewController];
//                });
//            }];
//            [alertControl addAction:okAction];
//            [LogicHandle presentViewController:alertControl animate:YES];
//        }
//    };
//    _index = 0;
//    self.currentRequestItem.task = [[LWNetworkSessionManager shareInstance]postPath:path parameters:parameters noAccesstoken:isNoAccesstoken withBlock:^(NSDictionary *result, NSError *error) {
//        [self getCurrentRequestItem:path];
//        [self precessResult:result error:error success:block];
//        [self requestEnd];
//        self.currentRequestItem.requesting = NO;
//    }];
}

- (void)resetBeginningState:(NSDictionary *)parameters {}

- (void)precessResult:(NSDictionary *)result error:(NSError *)error success:(void (^)(BOOL success))block{
    //此类由子类重写,主要是公共信息的处理(包括异常和正常数据)
    if (error) {
        NSLog(@"error:%@",error);
        if (self.showErrorMessage) {
            NSString *LocalizedDescription = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (LocalizedDescription && LocalizedDescription.length) {
                NSLog(@"NSLocalizedDescription:%@",LocalizedDescription);
            }else {
                NSString *DebugDescription = [error.userInfo objectForKey:@"NSDebugDescription"];
                if (DebugDescription && DebugDescription.length) {
                    NSLog(@"NSDebugDescription:%@",DebugDescription);
                }else {
                    NSLog(@"无网络连接");
                }
            }
        }
        //判断,无网络,访问超时等
        if([self.delegate respondsToSelector:@selector(coordinatorRequestError:)]){
            [self.delegate coordinatorRequestError:error];
        } else if (NSURLErrorTimedOut == error.code) {
            [self alterShowWithMessage:@"网络超时"];
        }
        
        if (block) {
            block(NO);
        }
    }else{
        NSString *code = [result ds_stringForKey:@"resultCode"];
        NSLog(@"%@",code);
        if ([code.lowercaseString isEqualToString:@"200"]) {
            id data = [result objectForKey:@"resultModel"];
            [self processOriginalData:data];
            if (block) {
                block(YES);
            }
        }else{
            if([self.delegate respondsToSelector:@selector(coordinatorRequestError:)]){
                [self.delegate coordinatorRequestError:error];
            }
            NSString *message = [result ds_stringForKey:@"resultMessage"];
            if (self.showErrorMessage) {
                if (message && message.length) {
                    NSLog(@"message-------->:%@",message);
//#ifdef DEBUG
//                    [SystemUtil showAlterViewWithMessage:message];
//#endif
                }else{
                    NSString *code = [result ds_stringForKey:@"resultCode"];
                    if (code && code.length) {
                        NSString *uppercaseCode = [code uppercaseString];
                        if ([uppercaseCode isEqualToString:@"1026"]) {

                        }else if ([uppercaseCode isEqualToString:@"ERR_SYS"]){
                            NSLog(@"系统异常");
                        }else if ([uppercaseCode isEqualToString:@"ERR_TOKEN_EXPIRED"]){
                            NSLog(@"未知错误!");
                        }
                    }else{
                        NSLog(@"未知错误!");
                    }
                }
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(coordinatorRequestError:)]){
                NSError *myError = [[NSError alloc] initWithDomain:kBaseAddress code:RequestErrorTypeServeBad userInfo:@{NSLocalizedDescriptionKey:message}];
                [self.delegate coordinatorRequestError:myError];
            }
            
            NSString *code = [result ds_stringForKey:@"resultCode"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(coordinator:resultCode:resultMessage:)]) {
                [self.delegate coordinator:self resultCode:[code integerValue] resultMessage:message];
            }
            
            if (block) {
                block(NO);
            }
        }
    }
}

- (void)requestEnd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(coordinator:requestEndAllCompleted:)]) {
        [self.delegate coordinator:self requestEndAllCompleted:self.currentRequestItem.loadedAllData];
        self.currentRequestItem.requesting = NO;
    }
}

- (void)precessResult:(NSDictionary *)result error:(NSError *)error complete:(void (^)(BOOL))success {

}

- (void)processOriginalData:(id)data {
    if ([self.delegate respondsToSelector:@selector(coordinator:data:)]) {
        [self.delegate coordinator:self data:data];
    }
    if (!self.currentRequestItem.loadedAllData && [data isKindOfClass:[NSArray class]]) {
        if (!data || [(NSArray *)data count] == 0) {
            [self setLoadedAllData:YES];
        }else {
            [self setLoadedAllData:NO];
        }
    }
}

+ (void)loadDataDirectWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))block {
//        [[LWNetworkSessionManager shareInstance] postPath:path parameters:parameters withBlock:^(NSDictionary *result, NSError *error) {
//            if (error) {
//
//            }else{
//                NSString *code = [result ds_stringForKey:@"resultCode"];
//                NSLog(@"%@",code);
//                if ([code.lowercaseString isEqualToString:@"200"]) {
//                    if (block) {
//                        block(result[@"result"]);
//                    }
//                }else{
//
//                }
//            }
//
//        }];
}

#pragma mark - getMethod
- (void)getDataWithPath:(NSString *)path {
    [self getDataWithPath:path parameters:nil requestSerializer:RequestSerializerTypeJson type:NSNotFound success:nil];
}

- (void)getDataWithPath:(NSString *)path type:(NSInteger)type {
    [self getDataWithPath:path parameters:nil requestSerializer:RequestSerializerTypeJson type:type success:nil];
}

- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    [self getDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:NSNotFound success:nil];
}

- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters noAccesstoken:(BOOL)isNoAccesstoken{
    [self getDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson noAccesstoken:isNoAccesstoken type:NSNotFound success:nil];
}

- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters requestSerializer:(RequestSerializerType)serializerType{
    [self getDataWithPath:path parameters:parameters requestSerializer:serializerType type:NSNotFound success:nil];
}

- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters type:(NSInteger)type {
    [self getDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:type success:nil];
}

- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(BOOL success))block  {
    [self getDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson type:NSNotFound success:block];
}

- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters requestSerializer:(RequestSerializerType )serializerType type:(NSInteger)type success:(void (^)(BOOL success))block {
    [self getDataWithPath:path parameters:parameters requestSerializer:serializerType noAccesstoken:NO type:type success:block];
}

- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters requestSerializer:(RequestSerializerType )serializerType noAccesstoken:(BOOL)isNoAccesstoken type:(NSInteger)type success:(void (^)(BOOL success))block {
    [self setSmsToken:nil];
//    if (![[LWNetworkSessionManager shareInstance].requestSerializer.HTTPRequestHeaders objectForKey:@"deviceId"]
//        || !([[LWNetworkSessionManager shareInstance].requestSerializer.HTTPRequestHeaders objectForKey:@"deviceId"].length > 0)) {
//        [LWDevice storeDeviceWithComplete:^{
//            [[LWNetworkSessionManager shareInstance] setDeviceIdForHeader];
//
//            [self getDataWithPath:path parameters:parameters requestSerializer:serializerType noAccesstoken:isNoAccesstoken type:type success:block];
//        }];
//
//        return;
//    }
    
    [self getCurrentRequestItem:path];
    self.currentRequestItem.type = type;
    if ([path isEqualToString:self.currentRequestItem.path] && self.currentRequestItem.requesting) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(coordinatorRepeatRequestFail)]) {
            [self.delegate coordinatorRepeatRequestFail];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(coordinatorBegainRequest)]) {
        self.currentRequestItem.requesting = YES;
        [self.delegate coordinatorBegainRequest];
    }
    [self resetBeginningState:parameters];
    __weak typeof(self) weakSelf = self;
//    self.nameBlock = ^(NSString *name, NSString *paramers) {
//        if([name isEqualToString:@"success"]){
//            [weakSelf getDataWithPath:path parameters:parameters requestSerializer:RequestSerializerTypeJson noAccesstoken:isNoAccesstoken type:NSNotFound success:block];
//        }else if ([name isEqualToString:@"success"]){
//            [weakSelf loadDataWithPath:path parameters:parameters noAccesstoken:isNoAccesstoken andSmsToken:paramers];
//        }else{
//            UIAlertController *alertControl = [UIAlertController  alertControllerWithTitle:nil message:@"登录信息过期,请重新登录" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [SystemUtil logoutDevice];
//            }];
//            [alertControl addAction:okAction];
//            [LogicHandle presentViewController:alertControl animate:YES];
//        }
//    };
//    _index = 0;
//    self.currentRequestItem.task = [[LWNetworkSessionManager shareInstance] getPath:path parameters:parameters noAccesstoken:isNoAccesstoken withBlock:^(NSDictionary *result, NSError *error) {
//        [self getCurrentRequestItem:path];
//        [self precessResult:result error:error success:block];
//        [self requestEnd];
//        self.currentRequestItem.requesting = NO;
//    }];

}

- (void)refreshToken{
//    [[LWNetworkSessionManager shareInstance] postPath:@"/api/app/next/user/token/refresh" parameters:@{@"refreshToken":[[LWUser shareInstance] getRefreshToken],@"accessToken":[[LWUser shareInstance]getToken ]} noAccesstoken:YES withBlock:^(NSDictionary *result, NSError *error) {
//        NSString *code = [result ds_stringForKey:@"resultCode"];
//        NSLog(@"%@",code);
//        if ([code.lowercaseString isEqualToString:@"200"]) {
//            NSDictionary *dataDic = [result objectForKey:@"resultModel"];
//            NSString *accessToken = [dataDic objectForKey:@"accessToken"];
//            NSString *refreshToken = [dataDic objectForKey:@"refreshToken"];
//            [[LWUser shareInstance]refreshToken:accessToken andRefreshToken:refreshToken];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.nameBlock(@"success",@"");
//            });
//            return ;
//        }else if([code.lowercaseString isEqualToString:@"1063"]){
//            UIAlertController *alertControl = [UIAlertController  alertControllerWithTitle:nil message:@"用户在其他设备登录，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SystemUtil logoutDeviceWithNOAction];
//                    [LogicHandle popToCurrentRootViewController];
//                });
//            }];
//            [alertControl addAction:cancelAction];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [SystemUtil logoutDeviceWithNOAction];
//                [SystemUtil showLoginWithTips:nil];
//
//            }];
//            [alertControl addAction:okAction];
//            [LogicHandle presentViewController:alertControl animate:YES];
//            if(self.delegate && [self.delegate respondsToSelector:@selector(coordinatorRequestError:)]){
//                [self.delegate coordinatorRequestError:nil];
//            }
//
//        }else if([code.lowercaseString isEqualToString:@"1001"]){
//            [SystemUtil logoutDeviceWithNOAction];
//            [LogicHandle popToCurrentRootViewController];
//            if(self.delegate && [self.delegate respondsToSelector:@selector(coordinatorRequestError:)]){
//                [self.delegate coordinatorRequestError:nil];
//            }
//
//        }else{
//            if (_index == 4) {
//                self.nameBlock(@"fail",@"");
//                return;
//            }
//            _index++;
//            [self refreshToken];
//        }
//    }];
}

- (void)alterShowWithMessage:(NSString *)message{
    [SVProgressHUD dismiss];
    UIAlertController *alertControl = [UIAlertController  alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertControl addAction:okAction];
//    [LogicHandle presentViewController:alertControl animate:YES];
}

- (void)setSmsToken:(NSString *)smsToken{
//    if (smsToken && ![smsToken isEqualToString:@""]) {
//        [[LWNetworkSessionManager shareInstance].requestSerializer setValue:smsToken forHTTPHeaderField:@"smsToken"];
//    }else{
//        [[LWNetworkSessionManager shareInstance].requestSerializer setValue:@"" forHTTPHeaderField:@"smsToken"];
//    }
}
@end
