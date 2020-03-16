//
//  PubkeyManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/12.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "PubkeyManager.h"
#import "PublicKeyView.h"

@implementation PubkeyManager
/*
 Printing description of data:
 {
     pk = 55a5667d673d7943e2759a4cf1519f1f92fac7cce57f07954e2985251611b246;
     publicKey = 02e441f94aafdf8ea3f9e7481c8c49d69bd6ccc8fbc8454b51b93b2edb8e78de44;
     seed = "robot before base tumble rocket dance element fabric deputy rail approve smile";
     shares =     (
         801aa2be0c71d3f3d8efd8cb345e0fba08ffc4cadf7fadaa1aa64413383abc2211dcc0faedbae4a96900fdecdbecb34db769af54074093f1a3d929d67d7a6ebcd0e3bb0cfe758bf8f1d9b776962da116a5f1ae07a70d11584ed65f845f2db102d38ff518cbf0d384c985eaf829a789c06c47ce040344770ef0e6c85642ae79f2eae9848856d5ae70e2ebabdc0d263776682eba525c7e3eed751eaf2bebca2,
         8024a5672938e7ec1015005ee8abdebf2037f98f6f37fa9cf495882c51b2b99f63a3e1ee2abd794513d95a11b6114683bec86f72ce8727e917a822758b3f7cb241cdc7de3d32c63b13a84ee65c4062260be9bdd94e0102ab0c778ed29f907203a707fa2aa63a7703d2d0d438f299025a3954cdd266839e05c1c4417a8547c23c9418e90b1dad4d3b35cff672cb96cee63196d572a9347c102a26ff9d065cf
     );
     xpub = xpub661MyMwAqRbcGfKM9mpToS76ULCFu5KuFmPP9XFYD39NoZ3BDnkDBNjHGSkFgE43n3AndaB6RSNUhGcaqqqB1m4rPS7BBYZwndkXdAMC3Jk;
 }
 */

+ (NSString *)getPubkey{
    NSDictionary *userdefault = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    if (userdefault) {
        NSString *pubKey = [userdefault objectForKey:@"publicKey"];
        if (pubKey && pubKey.length>0) {
            return pubKey;
        }
    }
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    __block int speakSessionIdBlock =0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[PublicKeyView shareInstance] getInitDataBlock:^(NSDictionary * _Nonnull dicData) {
            if (dicData) {
                [[NSUserDefaults standardUserDefaults] setObject:dicData forKey:kAppPubkeyManager_userdefault];
                [[NSUserDefaults standardUserDefaults] synchronize];
                speakSessionIdBlock = 100;// block代码中给变量赋值
                dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
            }else{
                dispatch_semaphore_signal(signal);
            }
        }];
    });

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    });
    return [self getPubkey];
}

+ (void)getPubKeyWithEmail:(NSString *)email SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    
    NSString *jsStr = [NSString stringWithFormat:@"getInitData('%@')",email];

    [[PublicKeyView shareInstance] getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            //返回来的shares需要使用js里的encrypt进行加密
            
             [[NSUserDefaults standardUserDefaults] setObject:dicData forKey:kAppPubkeyManager_userdefault];
             [[NSUserDefaults standardUserDefaults] synchronize];
             successBlock(dicData);
         }else{
             [self getPubKeyWithEmail:email SuccessBlock:successBlock WithFailBlock:FailBlock];
         }
    }];
}

+ (NSString *)getPrikey{
    NSDictionary *userdefault = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    if (userdefault) {
        NSString *prikey = [userdefault objectForKey:@"pk"];
        if (prikey && prikey.length>0) {
            return prikey;
        }
    }
    return nil;
    
//    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
//    __block int speakSessionIdBlock =0;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[PublicKeyView shareInstance] getInitDataBlock:^(NSDictionary * _Nonnull dicData) {
//            if (dicData) {
//                [[NSUserDefaults standardUserDefaults] setObject:dicData forKey:kAppPubkeyManager_userdefault];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                speakSessionIdBlock = 100;// block代码中给变量赋值
//                dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
//            }else{
//                dispatch_semaphore_signal(signal);
//            }
//        }];
//    });
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
//    });
//    return [self getPrikey];
}

+ (void)encriptwithPrikey:(NSString *)prikey andPubkey:(NSString *)Pubkey adnMessage:(NSString *)message WithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *jsStr = [NSString stringWithFormat:@"encrypt('%@','%@','%@')",prikey,Pubkey,message];
    [[PublicKeyView shareInstance] getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            successBlock(dicData);
         }else{
             
         }
    }];
}

+ (id)getRecoverData:(NSArray *)shares{
    
    NSString *jsStr = [NSString stringWithFormat:@"recover(%@)",shares];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    __block id returnObject;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[PublicKeyView shareInstance] getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
            if (dicData) {
                returnObject = dicData;
                 dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
             }else{
                 dispatch_semaphore_signal(signal);
             }
        }];
        
    });

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    });
    return returnObject;
}

+ (void)getdecriptwithPrikey:(NSString *)prikey andPubkey:(NSString *)Pubkey adnMessage:(NSString *)message WithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
NSString *jsStr = [NSString stringWithFormat:@"decrypt('%@','%@','%@')",prikey,Pubkey,message];
NSLog(@"prikey:%@",prikey);
NSLog(@"Pubkey:%@",Pubkey);
NSLog(@"message:%@",message);
    [[PublicKeyView shareInstance] getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
            if (dicData) {
                successBlock(dicData);
             }else{
             }
        }];
}

+ (void)getRecoverData:(NSArray *)shares WithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{

    NSString *sharesStr = [shares componentsJoinedByString:@"','"];
    NSString *jsStr = [NSString stringWithFormat:@"recover(['%@'])",sharesStr];
    
    [[PublicKeyView shareInstance] getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            [[LWUserManager shareInstance] setJiZhuCi:dicData];
            successBlock(dicData);
         }else{
         }
    }];
}

+ (void)getSigWithPK:(NSString *)pk message:(nonnull NSString *)message SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    
    NSString *jsStr = [NSString stringWithFormat:@"getWsSig({'message':'%@','pk':'%@'})",message,pk];
    
    PublicKeyView *pbView = [PublicKeyView shareInstance];
    [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            successBlock(dicData);
         }else{
         }
    }];
    

}

+ (void)getPrikeyByZhujiciSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *seed = [[LWUserManager shareInstance] getUserModel].jiZhuCi;
    NSString *jsStr = [NSString stringWithFormat:@"deriveKey('%@',0)",seed];
    
    LWUserModel *model = [[LWUserManager shareInstance] getUserModel];
    if (model.pk && model.pk.length>0) {
        successBlock(@{@"prikey":model.pk});
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        PublicKeyView *pbView = [PublicKeyView shareInstance];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
                if (dicData) {
                    LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
                    userModel.pk = [dicData objectForKey:@"prikey"];
                    [[LWUserManager shareInstance] setUser:userModel];
                    successBlock(dicData);
                    
                 }else{
                
                 }
            }];
        });

    });
}

+ (void)getPrikeyByZhujiciandIndex:(NSInteger)index SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *seed = [[LWUserManager shareInstance] getUserModel].jiZhuCi;
    NSString *jsStr = [NSString stringWithFormat:@"deriveKey('%@',%ld)",seed,(long)index];
    dispatch_async(dispatch_get_main_queue(), ^{
        PublicKeyView *pbView = [[PublicKeyView alloc] init];
        [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
            if (dicData) {
                successBlock(dicData);
             }else{
             }
            
        }];
    });
}

+ (void)getDkWithSecret:(NSString *)secret andpJoin:(id)dq SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *jsStr;
    if ([dq isKindOfClass:[NSArray class]]) {
        jsStr = [NSString stringWithFormat:@"encryptWithKey('%@','%@')",secret,[dq componentsJoinedByString:@","]];
    }else{
        jsStr = [NSString stringWithFormat:@"encryptWithKey('%@','%@')",secret,dq];
    }
    PublicKeyView *pbView = [PublicKeyView shareInstance];
    [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            successBlock(dicData);
         }else{
             FailBlock(dicData);
         }
    }];
}

+ (void)decrptWithNoAppendNumberSecret:(NSString *)secret ansMessage:(NSString *)eqrCodeStr SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *jsStr = [NSString stringWithFormat:@"decryptWithKey('%@','%@')",secret,eqrCodeStr];
    PublicKeyView *pbView = [PublicKeyView shareInstance];
    [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            successBlock(dicData);
         }else{
             FailBlock(dicData);
         }
    }];
}

//pass
+ (void)encrptWithTheKey:(NSString *)secret andSecret_share:(NSString *)secret_share SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *jsStr = [NSString stringWithFormat:@"encrypt_tss('%@','%@')",secret,secret_share];
    NSLog(@"%@",jsStr);
     PublicKeyView *pbView = [PublicKeyView shareInstance];
     [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
         if (dicData) {
             successBlock(dicData);
          }else{
              FailBlock(dicData);
          }
     }];
}


//index为0时存在问题
+ (void)decrptWithSecret:(NSString *)secret ansMessage:(NSString *)eqrCodeStr SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *jsStr = [NSString stringWithFormat:@"decryptWithKey('%@','%@',0)",secret,eqrCodeStr];
    PublicKeyView *pbView = [PublicKeyView shareInstance];
    [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            successBlock(dicData);
         }else{
             FailBlock(dicData);
         }
    }];
}

//pass
+ (void)decrptWithSecret:(NSString *)secret andSecret_share:(NSString *)codeStr SuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    NSString *jsStr = [NSString stringWithFormat:@"decrypt_tss('%@','%@')",secret,codeStr];
    PublicKeyView *pbView = [PublicKeyView shareInstance];
    [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            NSLog(@"decrypt_tss_sucess:%@",jsStr);
            successBlock(dicData);
         }else{
             NSLog(@"decrypt_tss_fail:%@",jsStr);
             FailBlock(dicData);
         }
    }];
}

@end
