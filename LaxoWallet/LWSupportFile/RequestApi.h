//
//  RequestApi.h
//  CQMServicePlatform
//
//  Created by yanbo on 2017/7/12.
//  Copyright © 2017年 yanbo. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef RequestApi_h
#define RequestApi_h

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define debugLog(...)
#define debugMethod()
#define NSLog(...)
#define LWLog(...) NSLog(__VA_ARGS__)
#endif

typedef NS_OPTIONS(NSInteger,ShareType){
    ShareTypeWeChat         = 1,//分享给微信好友
    ShareTypeWeChatFriend   = 2,//分享到朋友圈
    ShareTypeCopy           = 4,//拷贝链接
    ShareTypeQQ             = 3,//分享到QQ
};

typedef NS_OPTIONS(NSInteger, WSRequestId) {
    WSRequestIdWalletQueryPersonalWallet        = 10000,
    WSRequestIdWalletQueryMulpityWallet         = 10001,
    WSRequestIdWalletQueryTokenPrice            = 10002,
    WSRequestIdWalletQuerySingleAddress          = 10003,
    WSRequestIdWalletQueryCreatMultipyWallet     = 10004,
    WSRequestIdWalletQueryGetWalletMessageList   = 10005,
    WSRequestIdWalletQueryJoingNewWallet         = 10006,
    WSRequestIdWalletQueryMessageDetail         = 10007,


};


// 设备注册
static NSString * const kDeviceRegister = @"/api/app/next/user/device/register";
// 用户注册
static NSString * const kRegisterSendsmscode = @"/api/app/next/user/register/sendsmscode";

static NSString * const kAppSource = @"6";

#if 1
static NSString * const kBaseAddress = @"https://api.laxo.io/api.json?";

#else
static NSString * const kBaseAddress = @"http://116.62.146.57:8080/mobile";
//static NSString * const kBaseAddress = @"http://192.168.199.152:8099";
//static NSString * const kBaseAddress = @"http://192.168.199.171:8080";

#endif


#endif /* RequestApi_h */
