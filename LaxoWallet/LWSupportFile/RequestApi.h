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
    WSRequestIdWalletQueryMessageDetail          = 10007,
    WSRequestIdWalletQueryMessageListInfo        = 10008,
    WSRequestIdWalletQueryMessageParties         = 10009,
    WSRequestIdWalletQueryUserIsOnLine           = 10010,
    WSRequestIdWalletQueryBoardCast              = 10011,
    WSRequestIdWalletQueryGetTheKey              = 10012,
    WSRequestIdWalletQueryComfirmAddress         = 10013,
    WSRequestIdWalletQueryrequestPartySign       = 10014,//获取签名
    WSRequestIdWalletQueryGetKeyShare            = 10015,//获取签名前自己的share
    WSRequestIdWalletQueryBroadcastTrans         = 10016,//转账transfer
    
    WSRequestIdWalletQueryMultipyAddress         = 10017,//多人钱包收款地址
    WSRequestIdWalletQueryBroadcastUnSignTrans   = 10018,//多人转账未签名
    WSRequestIdWalletQuerySubmitSig              = 10019,//多人转账submit sig

    WSRequestId_multipy_broadcast_sig            = 10020,//多人钱包broadcast
    WSRequestId_multipy_pollBroadcast_sig        = 10021,//多人钱包pollbroadcast
    WSRequestId_multipy_broadcast_address        = 10022,//多人钱包broadcast
    WSRequestId_multipy_pollBroadcast_address    = 10023,//多人钱包pollbroadcast

    WSRequestId_scanLogin                        = 10024,//扫一扫登录

    WSRequestIdWallet_multipy_JoinWallet         = 10025,//加入钱包
    WSRequestIdWallet_multipy_sign        = 10026,//同意签名
    WSRequestIdWallet_multipy_rejectsign        = 10027,//拒绝签名
    WSRequestIdWallet_multipy_cancelTransaction        = 10028,//取消交易

    WSRequestIdWallet_resetWalletName        = 10029,//钱包名称设置
    WSRequestIdWallet_CreatePersonalWallet     = 10030,

    WSRequestId_paymail_queryByWid     = 10031,
    WSRequestId_paymail_update         = 10032,
    WSRequestId_paymail_setMain        = 10033,
    WSRequestId_paymail_query          = 10034,

    
};

#if 0
static NSString * const kBaseAddress = @"https://api.laxo.io/api.json?";
static NSString * const kWSAddress = @"wss://api.laxo.io/?";

#else
static NSString * const kBaseAddress = @"http://192.168.0.106:7001/api.json?";
static NSString * const kWSAddress = @"ws://192.168.0.106:7001/?";

#endif

// 人脸license文件名
#define FACE_LICENSE_NAME    @"idl-license"
// 人脸license后缀
#define FACE_LICENSE_SUFFIX  @"face-ios"
// （您申请的应用名称(appname)+「-face-ios」后缀，如申请的应用名称(appname)为test123，则此处填写test123-face-ios）
// 在后台 -> 产品服务 -> 人脸识别 -> 客户端SDK管理查看，如果没有的话就新建一个
#define FACE_LICENSE_ID        @"laxowallet-face-ios"


#endif /* RequestApi_h */
