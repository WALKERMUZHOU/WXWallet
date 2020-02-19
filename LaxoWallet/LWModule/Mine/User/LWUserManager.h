//
//  LWUserManager.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/8.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWUserManager : NSObject

+ (BOOL)isLogin;
+ (LWUserManager *)shareInstance;
- (void)setUser:(LWUserModel *)model;
- (void)setUserDic:(NSDictionary *)userDic;

- (void)clearUser;

- (LWUserModel *)getUserModel;

- (void)setEmail:(NSString *)email;
- (void)setJiZhuCi:(NSString *)string;
- (void)setLoginSuccess;
@end

NS_ASSUME_NONNULL_END
