//
//  LWUserModel.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWUserModel.h"

@implementation LWUserModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    NSString *uid = [NSString stringWithFormat:@"%@", [dic objectForKey:@"uid"]];
    if (uid && uid.length>0) {
        self.uid = uid;
    }
//    NSDictionary *tokenDic = [dic ds_dictionaryForKey:@"token"];
//    self.accessToken = [tokenDic ds_stringForKey:@"accessToken"];
//    self.authType = [tokenDic ds_integerForKey:@"authType"];
//    self.expires = [tokenDic ds_stringForKey:@"expires"];
//    self.platform = [tokenDic ds_integerForKey:@"platform"];
//    self.refreshToken = [tokenDic ds_stringForKey:@"refreshToken"];
//    self.sessionId = [tokenDic ds_stringForKey:@"sessionId"];
//    self.userId= [tokenDic ds_stringForKey:@"userId"];
    return YES;
}
@end
