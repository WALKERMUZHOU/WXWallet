//
//  LWLoginCoordinator.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginCoordinator.h"
#import "PubkeyManager.h"

@implementation LWLoginCoordinator

+ (void)getSMSCodeWithEmail:(NSString *)email WithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *emailStr = email;

    NSDate *datenow = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *intervalStr = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    NSString *keyStr = @"c51bbbac6fb44c41e87c718118359aea5ca63bca5356ffd5cbb6fba86d30165d";
    NSArray *keyArray =@[keyStr,emailStr,intervalStr];
    NSString *keyH = [keyArray componentsJoinedByString:@""];
    NSString *keyHMD5 = [keyH md5String];

    NSDictionary *paramers = @{@"email":emailStr,@"t":intervalStr,@"h":keyHMD5};
    NSString *jsonStr = [paramers jsonStringEncoded];
    
    [[LWNetWorkSessionManager shareInstance] getPath:Url_Login_SendCode parameters:@{@"params":jsonStr} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            successBlock(result);
        }else{
            if (error) {
                FailBlock(error);
            }else{
                FailBlock(result);
            }
        }
    }];
}

+ (void)verifyEmailCodeWithEmail:(NSString *)email andCode:(NSString *)code WithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    
    NSDictionary *paramers = @{@"email":email,@"code":code};
    NSString *jsonStr = [paramers jsonStringEncoded];
    
    [[LWNetWorkSessionManager shareInstance] getPath:Url_Login_VerifyEmail parameters:@{@"params":jsonStr} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            successBlock(result);
        }else{
            if (error) {
                FailBlock(error);
            }else{
                FailBlock(result);
            }
        }
    }];
}

+ (void)getRecoverySMSCodeWithModel:(LWTrusteeModel *)model SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    
    
    NSString *pubKey = [PubkeyManager getPubkey];
    
    NSDictionary *paramers = @{@"token":[[LWUserManager shareInstance]getUserModel].token,@"pubkey":pubKey,@"trustee":model.name};
    NSString *jsonStr = [paramers jsonStringEncoded];
    NSLog(@"RecoverCode:%@",jsonStr);
    [[LWNetWorkSessionManager shareInstance] getPath:Url_Login_requestRecoverCode parameters:@{@"params":jsonStr} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            successBlock(result);
        }else{
            if (error) {
                FailBlock(error);
            }else{
                FailBlock(result);
            }
        }
    }];
    
}

+ (void)verifyRecoveryEmailCodeWithCode:(NSString *)code andModel:(LWTrusteeModel *)model WithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    
    NSDictionary *paramers = @{@"token":[[LWUserManager shareInstance]getUserModel].token,@"code":code,@"trustee":model.name};
    NSString *jsonStr = [paramers jsonStringEncoded];
    
    [[LWNetWorkSessionManager shareInstance] getPath:Url_Login_requestRecover parameters:@{@"params":jsonStr} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            successBlock(result);
        }else{
            if (error) {
                FailBlock(error);
            }else{
                FailBlock(result);
            }
        }
    }];
}

+ (void)getTrueteeDataWithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    
    [[LWNetWorkSessionManager shareInstance] getPath:Url_Login_trustee parameters:@{} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            NSArray *dataArray = [result objectForKey:@"data"];
            [[LWTrusteeManager shareInstance] setTrustee:dataArray];
            NSLog(@"gettrusteeSuccess");
            successBlock(result);
        }else{
            if (error) {
                FailBlock(error);
            }else{
                FailBlock(result);
            }
        }
    }];
}

+ (void)registerUserWithEmail:(NSString *)email WithSuccessBlock:(nonnull void (^)(id _Nonnull))successBlock WithFailBlock:(nonnull void (^)(id _Nonnull))FailBlock{
    
    NSDictionary *paramers = @{@"token":[[LWUserManager shareInstance]getUserModel].token,@"email":email,@"shares":@""};
    NSString *jsonStr = [paramers jsonStringEncoded];
    
    [[LWNetWorkSessionManager shareInstance] getPath:Url_Login_register parameters:@{@"params":jsonStr} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            successBlock(result);
        }else{
            if (error) {
                FailBlock(error);
            }else{
                FailBlock(result);
            }
        }
    }];
}

+ (void)registerUserWithParams:(NSDictionary *)params WithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *jsonStr = [params jsonStringEncoded];

    [[LWNetWorkSessionManager shareInstance] getPath:Url_Login_register parameters:@{@"params":jsonStr} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            successBlock([result objectForKey:@"data"]);
        }else{
            if (error) {
                FailBlock(error);
            }else{
                FailBlock(result);
            }
        }
    }];
}
@end
