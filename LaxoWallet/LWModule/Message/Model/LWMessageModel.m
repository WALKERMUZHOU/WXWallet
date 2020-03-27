//
//  LWMessageModel.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageModel.h"

@implementation LWMessageModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"messageId":@"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    if ([[dic objectForKey:@"status"] integerValue] == 1) {
        self.viewHeight= 290;
    }else if ([[dic objectForKey:@"status"] integerValue] == 2){
        if ([[dic objectForKey:@"type"] integerValue] == 1) {
            self.viewHeight = 270;
        }else{
            self.viewHeight = 245;
        }
    }
    NSArray *partiesArray = [dic objectForKey:@"parties"];
    if (partiesArray.count>0) {
        self.parties = [NSArray modelArrayWithClass:[LWPartiesModel class] json:partiesArray];
    }
    
    NSString *uid = [[LWUserManager shareInstance] getUserModel].uid;
    NSString *walletUid = [NSString stringWithFormat:@"%@", [dic objectForKey:@"uid"]];
    if ([uid isEqualToString:walletUid]) {
        self.isMineCreateTrans = YES;
    }
    
    NSDictionary *user_status = [dic objectForKey:@"user_status"];
    NSArray *approve = [user_status ds_arrayForKey:@"approve"];
    if (approve.count > 0) {
        self.approve = approve;
    }
    
    NSArray *reject = [user_status ds_arrayForKey:@"reject"];
    if (reject.count > 0) {
        self.reject = reject;
    }
    
    
    if([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY){
        
        NSInteger value = [[dic objectForKey:@"value"] integerValue];
        self.priceDefine = [NSString stringWithFormat:@"¥ %.2f",[LWPublicManager getCurrentCurrencyPrice].floatValue * value/1e8];
    }else{
        NSInteger value = [[dic objectForKey:@"value"] integerValue];
        self.priceDefine = [NSString stringWithFormat:@"$ %.2f",[LWPublicManager getCurrentCurrencyPrice].floatValue * value/1e8];
    }
    
    return YES;
}

@end
