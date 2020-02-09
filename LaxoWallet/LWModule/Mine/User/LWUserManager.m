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
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
    [archiver encodeObject:self.model forKey:kUserInfo_key];
    [archiver finishEncoding];
    [deviceData writeToFile:[[self class] obtainDeviceDataPath] atomically:YES];
}

/**
 decode
 
 @return LWUserModel
 */
- (LWUserModel *)userInfoUnArchieve{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[[self class] obtainDeviceDataPath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
    
//   NSKeyedUnarchiver *archiver = [[NSKeyedUnarchiver alloc] initRequiringSecureCoding:YES];
    LWUserModel *model = [unarchiver decodeObjectForKey:kUserInfo_key];
    [unarchiver finishDecoding];
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
    if (model && model.uid && ![model.uid isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (void)setUser:(LWUserModel *)model{
    [self userInfoArchieve:model];
}

- (void)clearUser{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[[self class] obtainDeviceDataPath]]) {
        [defaultManager removeItemAtPath:[[self class] obtainDeviceDataPath] error:nil];
    }
}

- (LWUserModel *)getUserModel{
    return [self userInfoUnArchieve];
}

@end
