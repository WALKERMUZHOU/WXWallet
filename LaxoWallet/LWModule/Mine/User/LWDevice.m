//
//  LWDevice.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWDevice.h"
#import "LWNetWorkSessionManager.h"

static NSString * const kAesKey_id = @"aesKey_id";      // 解密秘钥
static NSString * const kDeviceId = @"deviceId_id";     // 设备号

static NSString * const kAppVersion = @"appVersion_id"; // app版本
static NSString * const kDeviceType = @"deviceType_id"; // 设备类型
static NSString * const kOsName = @"osName_id";         // 操作系统名称
static NSString * const kOsVersion = @"osVersion_id";   // 操作系统版本
static NSString * const kUniqueId = @"uniqueId_id";     // UUID

static NSString * const kDeviceDataKey = @"device_data";        // 归档key键
static NSString * const kDeviceDataFileName = @"device.data";   // 归档文件名

@interface LWDevice () <NSCoding>


@end

@implementation LWDevice

+ (void)storeDevice {
    
    [self storeDeviceWithComplete:nil];
}

+ (void)storeDeviceWithComplete:(void(^)(void))complete {
    
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *deviceType = @"0";
//    NSString *osName = [[UIDevice currentDevice] name];
//    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
//    NSString *uniqueId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
//
//    NSDictionary *parameters = @{
//                                 kAppVersionKey:appVersion
//                                 ,kDeviceTypeKey:deviceType
//                                 ,kOsNameKey:osName
//                                 ,kOsVersionKey:osVersion
//                                 ,kUniqueIdKey:uniqueId
//                                 };
//
//    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionaryWithDictionary:parameters];
//
//    [[LWNetworkSessionManager shareInstance] postPath:kDeviceRegister parameters:parameters withBlock:^(NSDictionary *result, NSError *error) {
//
//        if (error) {
//            [self storeDevice];
//        }else{
//            if (kSuccessCode == [[result objectForKey:kResultCode] integerValue]) {
//                [deviceInfo setValuesForKeysWithDictionary:[result objectForKey:kResultModel]];
//
//                LWDevice *device = [self deviceWithInfo:[NSDictionary dictionaryWithDictionary:deviceInfo]];
//
//                [device storeToLocal];
//            }else{
//                [self storeDevice];
//            }
//        }
//
//        if (complete) {
//
//            complete();
//        }
//
//    }];
    
}

- (void)storeToLocal {
    //归档
    NSMutableData *deviceData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:deviceData];

    [archiver encodeObject:self forKey:kDeviceDataKey];
    [archiver finishEncoding];

    [deviceData writeToFile:[[self class] obtainDeviceDataPath] atomically:YES];
}

//+ (instancetype)deviceWithInfo:(NSDictionary *)info {
//    
//    LWDevice *device = [[[self class] alloc] init];
//    
//    device.aesKey = [info objectForKey:kAesKey];
//    device.deviceId = [info objectForKey:kDeviceIdKey];
//    
//    device.appVersion = [info objectForKey:kAppVersionKey];
//    device.deviceType = [info objectForKey:kDeviceTypeKey];
//    device.osName = [info objectForKey:kOsNameKey];
//    device.osVersion = [info objectForKey:kOsVersionKey];
//    device.uniqueId = [info objectForKey:kUniqueIdKey];
//    
//    return device;
//}

+ (instancetype)obtainDevice {
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self obtainDeviceDataPath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    LWDevice *device = [unarchiver decodeObjectForKey:kDeviceDataKey];
    [unarchiver finishDecoding];
    
    if (device) {
        return device;
    }
    
    return nil;
}

+ (NSString *)obtainDeviceDataPath {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *deviceDataPath = [path stringByAppendingPathComponent:kDeviceDataFileName];
    
    return deviceDataPath;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.aesKey forKey:kAesKey_id];
    [aCoder encodeObject:self.deviceId forKey:kDeviceId];
    [aCoder encodeObject:self.appVersion forKey:kAppVersion];
    [aCoder encodeObject:self.deviceType forKey:kDeviceType];
    [aCoder encodeObject:self.osName forKey:kOsName];
    [aCoder encodeObject:self.osVersion forKey:kOsVersion];
    [aCoder encodeObject:self.uniqueId forKey:kUniqueId];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        //
        self.aesKey = [aDecoder decodeObjectForKey:kAesKey_id];
        self.deviceId = [aDecoder decodeObjectForKey:kDeviceId];
        self.appVersion = [aDecoder decodeObjectForKey:kAppVersion];
        self.deviceType = [aDecoder decodeObjectForKey:kDeviceType];
        self.osName = [aDecoder decodeObjectForKey:kOsName];
        self.osVersion = [aDecoder decodeObjectForKey:kOsVersion];
        self.uniqueId = [aDecoder decodeObjectForKey:kUniqueId];
    }
    
    return self;
}
@end
