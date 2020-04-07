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
        
    NSArray *partiesArray = [dic objectForKey:@"parties"];
    if (partiesArray && partiesArray.count>0) {
        self.parties = [NSArray modelArrayWithClass:[LWPartiesModel class] json:partiesArray];
    }
    
    NSString *uid = [[LWUserManager shareInstance] getUserModel].uid;
    NSString *walletUid = [NSString stringWithFormat:@"%@", [dic objectForKey:@"uid"]];
    if ([uid isEqualToString:walletUid]) {
        self.isMineCreateTrans = YES;
    }
    
    NSDictionary *user_status = [dic objectForKey:@"user_status"];
    if (user_status) {
        NSArray *approve = [user_status ds_arrayForKey:@"approve"];
        if (approve.count > 0) {
            self.approve = approve;
        }
        
        NSArray *reject = [user_status ds_arrayForKey:@"reject"];
        if (reject.count > 0) {
            self.reject = reject;
        }
    }

    return YES;
}

@end
