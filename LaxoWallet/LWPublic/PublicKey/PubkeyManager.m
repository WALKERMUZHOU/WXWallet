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

+ (NSString *)getPrikey{
    NSDictionary *userdefault = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    if (userdefault) {
        NSString *prikey = [userdefault objectForKey:@"pk"];
        if (prikey && prikey.length>0) {
            return prikey;
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
    return [self getPrikey];
}

+ (NSString *)getencriptwithPrikey:(NSString *)prikey andPubkey:(NSString *)Pubkey adnMessage:(NSString *)message{
    
    NSString *jsStr = [NSString stringWithFormat:@"decrypt('%@','%@','%@')",prikey,Pubkey,message];
    NSLog(@"prikey:%@",prikey);
    NSLog(@"Pubkey:%@",Pubkey);
    NSLog(@"message:%@",message);

//    NSString *jsStr = @"encrypt('41c94deddfaea83f90c059cead1dca04151023b63fc827818f686b9e83bc69b9','03093b9db836a833554bacdf9f6aadb5dd2048d202caefc4a5e8cb6a63a89ef8d5','c2cc5d7b991cbaf2ef5b9221312c1326d855acd7e16a04207ee01420b0e80e3c641dd1a69de55153e645e69003209069a6a895f4d9d40b5e3f5ac3c2df54702f')";

    __block NSString *returnStr;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        [[PublicKeyView shareInstance] getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
            if (dicData) {
                returnStr = (NSString *)dicData;
                NSLog(@"jsReturnStr:%@",returnStr);
                 dispatch_semaphore_signal(signal);// 发送信号 下面的代码一定要写在赋值完成的下面
             }else{
                 dispatch_semaphore_signal(signal);
             }
        }];
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    });

    return returnStr;
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
@end
