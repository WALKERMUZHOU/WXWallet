//
//  LWDevice.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWDevice : NSObject

@property (nonatomic, copy) NSString *aesKey;   // 解密秘钥
@property (nonatomic, copy) NSString *deviceId; // 设备号

@property (nonatomic, copy) NSString *appVersion;   // app版本
@property (nonatomic, copy) NSString *deviceType;   // 设备类型
@property (nonatomic, copy) NSString *osName;       // 操作系统名称
@property (nonatomic, copy) NSString *osVersion;    // 操作系统版本
@property (nonatomic, copy) NSString *uniqueId;     // UUID

// 发起请求，存储device信息
+ (void)storeDevice;
+ (void)storeDeviceWithComplete:(void(^)(void))complete;

// 获取本地存储的device信息
+ (instancetype)obtainDevice;

@end

NS_ASSUME_NONNULL_END
