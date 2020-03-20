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


static NSString * const Url_Login_trustee = @"method=wallet.trustholds";    // 发送trustee码
static NSString * const Url_Login_SendCode = @"method=user.sendCode";    // 发送验证码
static NSString * const Url_Login_VerifyEmail = @"method=user.verifyEmail";//验证邮箱
static NSString * const Url_Login_requestRecoverCode = @"method=user.requestRecover";// 请求恢复验证码
static NSString * const Url_Login_requestRecover = @"method=user.recover";// 恢复
static NSString * const Url_Login_register = @"method=user.register";//注册

static NSString * const Url_Login_registerFace = @"method=user.addFace";//
static NSString * const Url_Login_checkFace = @"method=user.queryFace";//



static NSString * const Url_Home_tokenPrice = @"method=wallet.tokenPrice";//获取实时价格
static NSString * const Url_Home_SingleAddress = @"method=wallet.createSingleAddress";//获取个人收款地址

static NSString * const WS_Login_ScanLogin = @"user.doLogin";//扫一扫登录


static NSString * const WS_Home_MessageList = @"wallet.queryTransaction";//获取消息列表
static NSString * const WS_Home_MessageParties = @"wallet.queryParties";//获取多方信息

static NSString * const WS_Home_UserIsOnLine = @"user.isOnline";//查询用户在线

static NSString * const WS_Home_boardcast = @"message.set";//个人收款二维码,广播
static NSString * const WS_Home_getTheKey = @"message.get";//个人收款二维码，getTheKey
static NSString * const WS_Home_confirmAdress = @"wallet.confirmAddress";//个人收款地址
static NSString * const WS_Home_requestPartySign = @"wallet.requestPartySign";//签名
///签名前得到自己的share
static NSString * const WS_Home_getKeyShare = @"wallet.getKeyShare";
static NSString * const WS_Home_getMutipyAddress = @"wallet.createMultiPartyAddress";
///多人收款地址
static NSString * const WS_Home_multipyConfirmAdress = @"wallet.addShare";
static NSString * const WS_Home_multipyUnSignTrans = @"wallet.createTransaction";
static NSString * const WS_Home_multipySubmitSig = @"wallet.submitSig";

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
