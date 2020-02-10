//
//  RequestKeyDefine.h
//  CQMServicePlatform
//
//  Created by yanbo on 2017/7/13.
//  Copyright © 2017年 yanbo. All rights reserved.
//

#ifndef RequestKeyDefine_h
#define RequestKeyDefine_h

static NSString * const kResultMessage = @"resultMessage";
static NSString * const kResultModel = @"resultModel";
static NSString * const kResultCode = @"resultCode";

static NSString * const kAesKey = @"aesKey";        // 解密秘钥
static NSString * const kDeviceIdKey = @"deviceId";    // 设备号

static NSString * const kAppVersionKey = @"appVersion"; // app版本
static NSString * const kDeviceTypeKey = @"deviceType"; // 设备类型
static NSString * const kOsNameKey = @"osName";         // 操作系统名称
static NSString * const kOsVersionKey = @"osVersion";   // 操作系统版本
static NSString * const kUniqueIdKey = @"uniqueId";     // UUID

static NSString * const kRegisterMobile = @"mobile";    // 用户注册手机号


static NSString * const Url_Login_trustee = @"method=wallet.trustee";    // 发送trustee码

static NSString * const Url_Login_SendCode = @"method=user.sendCode";    // 发送验证码
static NSString * const Url_Login_VerifyEmail = @"method=user.verifyEmail";//验证邮箱
static NSString * const Url_Login_requestRecoverCode = @"method=user.requestRecover";    // 恢复验证码
static NSString * const Url_Login_requestRecover = @"method=user.recover";    // 恢复请求


//系统版本
#define kSystemVersion [[UIDevice currentDevice]systemVersion].floatValue
//app版本
#define kAppVersionDesign [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBundleValueDesign [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];


#define NotificationUserInfo  @"NotificationUserInfo"
#define NotificationBecomeActive    @"NotificationBecomeActive"
#define NotificationBadgeAdd    @"NotificationBadgeAdd"


#endif /* RequestKeyDefine_h */
