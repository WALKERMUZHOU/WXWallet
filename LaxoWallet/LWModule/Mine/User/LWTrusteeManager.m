//
//  LWTrusteeManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/9.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWTrusteeManager.h"

static NSString * const kTrusteeInfo_key = @"kTrusteeInfo_key";
static NSString * const kTrusteerInfo_File_Name = @"kTrusteeInfo.data";

@interface LWTrusteeManager ()<NSCoding>

@property (nonatomic, strong) NSArray *trusteeArr;

@end


@implementation LWTrusteeManager

static LWTrusteeManager *instance = nil;
+ (LWTrusteeManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWTrusteeManager alloc]init];
    });
    return instance;
}


- (void)trusteeInfoArchieve:(NSArray *)model{
    [self clearTrustee];
    self.trusteeArr = model;
    NSMutableData *deviceData = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:deviceData];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    NSData *archiverdata = [NSKeyedArchiver archivedDataWithRootObject:self.trusteeArr requiringSecureCoding:NO error:nil];
//    [archiver encodeObject:self.trusteeArr forKey:kTrusteeInfo_key];
//    [archiver finishEncoding];
    [archiverdata writeToFile:[[self class] obtainDeviceDataPath] atomically:YES];
}

- (NSArray *)trusteeInfoUnArchieve{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[[self class] obtainDeviceDataPath]];
//    [NSKeyedUnarchiver unarchiveObjectWithData:data exception:nil];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
    NSArray *model = [NSKeyedUnarchiver unarchiveObjectWithData:data exception:nil];
//    [unarchiver finishDecoding];
    return model;
}

/**
 path
 @return data path
 */
+ (NSString *)obtainDeviceDataPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *deviceDataPath = [path stringByAppendingPathComponent:kTrusteerInfo_File_Name];
    return deviceDataPath;
}

- (void)setTrustee:(NSArray *)trusteeArray{
    [self trusteeInfoArchieve:trusteeArray];
}

- (void)clearTrustee{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[[self class] obtainDeviceDataPath]]) {
        [defaultManager removeItemAtPath:[[self class] obtainDeviceDataPath] error:nil];
    }
}

- (LWTrusteeModel *)getFirstModel{
    NSArray *trusteeArr = [self getTrusteeArray];
    if (trusteeArr.count>0) {
        return trusteeArr.firstObject;
    }
    return nil;
}

- (NSArray<LWTrusteeModel *> *)getTrusteeArray{
    NSArray *trusteeArr = [self trusteeInfoUnArchieve];
    return [NSArray modelArrayWithClass:[LWTrusteeModel class] json:trusteeArr];
}

@end
