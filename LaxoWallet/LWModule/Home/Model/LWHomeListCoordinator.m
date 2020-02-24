//
//  LWHomeListCoordinator.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListCoordinator.h"

@implementation LWHomeListCoordinator

+ (void)getTokenPriceWithSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    [[LWNetWorkSessionManager shareInstance] getPath:Url_Home_tokenPrice parameters:@{} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            NSArray *dataArray = [result objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:kAppTokenPrice_userdefault];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"kAppTokenPrice_userdefault");
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

+ (void)getCollectionCodeWithWalletId:(NSInteger)walletID withSuccessBlock:(void (^)(id _Nonnull))successBlock WithFailBlock:(void (^)(id _Nonnull))FailBlock{
    
    NSDictionary *paramers = @{@"wid":@(walletID)};
    NSString *jsonStr = [paramers jsonStringEncoded];
    
    [[LWNetWorkSessionManager shareInstance] postPath:Url_Home_SingleAddress parameters:@{@"params":jsonStr} withBlock:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] integerValue] == 1) {//success
            NSArray *dataArray = [result objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:kAppTokenPrice_userdefault];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"kAppTokenPrice_userdefault");
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

@end
