//
//  LWUserManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/8.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWUserManager.h"

static NSString * const kUserInfo_key = @"kUserInfo_key";
static NSString * const kUserInfo_File_Name = @"kUserInfo.data";

@interface LWUserManager ()

@property (nonatomic, strong) LWUserModel *model;

@end

@implementation LWUserManager

static LWUserManager *instance = nil;
+ (LWUserManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWUserManager alloc]init];
    });
    return instance;
}

/**
 code
 
 @param model userModel
 */
- (void)userInfoArchieve:(LWUserModel *)model{
    [self clearUser];
    self.model = model;
    NSMutableData *deviceData = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:deviceData];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
//    [archiver encodeObject:self.model forKey:kUserInfo_key];
//    [archiver finishEncoding];
    NSData *daaarc = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:NO error:nil];
    [daaarc writeToFile:[[self class] obtainDeviceDataPath] atomically:YES];
}

/**
 decode
 
 @return LWUserModel
 */
- (LWUserModel *)userInfoUnArchieve{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[[self class] obtainDeviceDataPath]];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
    
//   NSKeyedUnarchiver *archiver = [[NSKeyedUnarchiver alloc] initRequiringSecureCoding:YES];
    LWUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data exception:nil];
//    [unarchiver finishDecoding];
    return model;
}

/**
 path
 
 @return data path
 */
+ (NSString *)obtainDeviceDataPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *deviceDataPath = [path stringByAppendingPathComponent:kUserInfo_File_Name];
    return deviceDataPath;
}

+ (BOOL)isLogin{
    LWUserModel *model = [[LWUserManager shareInstance] userInfoUnArchieve];
    if (model && model.uid && model.loginSuccess.length >0) {
        return YES;
    }
    return NO;
}

- (void)setUser:(LWUserModel *)model{
    [self userInfoArchieve:model];
}

- (void)setUserDic:(NSDictionary *)userDic{
    LWUserModel *model = [LWUserModel modelWithDictionary:userDic];
    [self userInfoArchieve:model];
}

- (void)setEmail:(NSString *)email{
    LWUserModel *userModel = [self getUserModel];
    userModel.email = email;
    [self userInfoArchieve:userModel];
}


- (void)clearUser{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[[self class] obtainDeviceDataPath]]) {
        [defaultManager removeItemAtPath:[[self class] obtainDeviceDataPath] error:nil];
    }
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault removeObjectForKey:kRevocerSuccessKey_userdefault];
    [userdefault synchronize];
}

- (LWUserModel *)getUserModel{
    return [self userInfoUnArchieve];
}

- (void)setJiZhuCi:(NSString *)string{
    LWUserModel *userModel = [self getUserModel];
    userModel.jiZhuCi = string;
    [self userInfoArchieve:userModel];
}

- (void)setLoginSuccess{
    LWUserModel *userModel = [self getUserModel];
    userModel.loginSuccess = @"success";
    [self userInfoArchieve:userModel];
}

@end
