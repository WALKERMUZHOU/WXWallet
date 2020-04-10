//
//  AppDelegate.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/4.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "AppDelegate.h"
#import "LWLoginViewController.h"
#import "LWLoginCoordinator.h"
#import "LWHomeListCoordinator.h"

#import "PublicKeyView.h"
#import "LWRocoveryViewController.h"
#import "LWFaceBindViewController.h"
#import "LWPersonalWalletDetailViewController.h"

#import "LWUserVefifyViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import <Bugly/Bugly.h>

#import <GTSDK/GeTuiSdk.h>                          // GTSDK 头文件
#import <PushKit/PushKit.h>                         // VOIP支持需要导入PushKit库,实现 PKPushRegistryDelegate
#import <UserNotifications/UserNotifications.h>     // iOS10 通知头文件

#import "LWCurrentExchangeTool.h"
#import "LWNotificationTool.h"
@interface AppDelegate ()<PKPushRegistryDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
@property (strong, nonatomic) UIVisualEffectView *blurView;
@end

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [_blurView removeFromSuperview];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
     if(!_blurView) {
     UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
     _blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     _blurView.frame = self.window.bounds;
     }
    //进入后台实现模糊效果
     [self.window addSubview:_blurView];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD dismissWithDelay:10];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self getTrueteeData];
    [self getCurrencyToUSD];
    [[LWCurrentExchangeTool shareInstance] getCurrentExchange];
    [self registerBDFace];
    
    [LogicHandle showTabbarVC];
//    [LogicHandle chooseStartVC];
//    [LogicHandle showLoginVC];

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self registerBugly];
        [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
        [self registerRemoteNotification];
    });
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)getCurrencyToUSD{
    [LWHomeListCoordinator getCurrentCurrencyWithUSDWithSuccessBlock:^(id  _Nonnull data) {
        
    } WithFailBlock:^(id  _Nonnull data) {
        [self getCurrencyToUSD];
    }];
}

- (void)getTrueteeData{
    [LWLoginCoordinator getTrueteeDataWithSuccessBlock:^(id  _Nonnull data) {
        
    } WithFailBlock:^(id  _Nonnull data) {
        [self getTrueteeData];
    }];
}

- (void)registerBDFace{
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
     NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
     [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
}

#pragma mark - getui
#pragma mark - 用户通知(推送) _自定义方法

/**
 * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
 *
 * 警告：Xcode8及以上版本需要手动开启“TARGETS -> Capabilities -> Push Notifications”
 * 警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。以下为参考代码
 * 注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
 *
 */
- (void)registerRemoteNotification {
    if (@available(iOS 10,*)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error && granted) {
                NSLog(@"[ TestDemo ] iOS 10 request authorization succeeded!");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        return;
    }else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
            return;
        }
    }
}

#pragma mark - 远程通知(推送)回调

/// [ 系统回调 ] 远程通知注册成功回调，获取DeviceToken成功，同步给个推服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [ GTSDK ]：（新版）向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceTokenData:deviceToken];
    
    // [ 测试代码 ] 日志打印DeviceToken
    NSLog(@"[ TestDemo ] [ DeviceToken(NSData) ]: %@\n", deviceToken);
}

/// [ 系统回调:可选 ] 远程通知注册失败回调，获取DeviceToken失败，打印错误信息
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    // [ 测试代码 ] 日志打印错误信息
    NSLog(@"[ TestDemo ] [DeviceToken Error]: %@\n", error.description);
}

#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/// [ 系统回调 ] iOS 10 通知方法: APNs通知将要显示时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    // [ 测试代码 ] 日志打印APNs信息
    NSLog(@"[ TestDemo ] [APNs] %@：%@", NSStringFromSelector(_cmd), notification.request.content.userInfo);
    
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

/// [ 系统回调 ] iOS 10 通知方法: APNs点击通知时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    // [ 测试代码 ] 日志打印APNs信息
    NSLog(@"通知点击响应：[ TestDemo ] [APNs] %@ \nTime:%@ \n%@",
          NSStringFromSelector(_cmd),
          response.notification.date,
          response.notification.request.content.userInfo);
    
    // [ GTSDK ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    [LWNotificationTool manageNotifictionObject:response.notification.request.content.userInfo];
    completionHandler();
}
#endif

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/// [ 系统回调 ] App收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    // [ 测试代码 ] 日志打印APNs信息
    NSLog(@"[ TestDemo ] [APNs] %@：%@", NSStringFromSelector(_cmd), userInfo);
    
    // [ GTSDK ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    [LWNotificationTool manageNotifictionObject:userInfo];
//    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
//
//    //指定声音文件弹窗
//
//    [EBForeNotification handleRemoteNotification:userInfo customSound:@"my_sound.wav"];
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
    completionHandler(UIBackgroundFetchResultNewData);
}

//#pragma mark - VOIP 接入
//
///**
// * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册VOIP服务
// *
// * 警告：以下为参考代码, 注意根据实际需要修改.
// *
// */
//- (void)voipRegistration {
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue:mainQueue];
//    voipRegistry.delegate = self;
//    // Set the push type to VoIP
//    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
//}
//
//#pragma mark PKPushRegistryDelegate 协议方法
//
///// [ 系统回调 ] 系统返回VOIPToken，并提交个推服务器
//- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
//    // [ GTSDK ]：（新版）向个推服务器注册 VoipToken
//    [GeTuiSdk registerVoipTokenCredentials:credentials.token];
//
//    // [ 测试代码 ] 日志打印DeviceToken
//    NSLog(@"[ TestDemo ] [ VoipToken(NSData) ]: %@\n\n", credentials.token);
//}
//
///**
// * [ 系统回调 ] 收到voip推送信息
// * 接收VOIP推送中的payload进行业务逻辑处理（一般在这里调起本地通知实现连续响铃、接收视频呼叫请求等操作），并执行个推VOIP回执统计
// */
//- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
//    //  [ GTSDK ]：个推VOIP回执统计
//    [GeTuiSdk handleVoipNotification:payload.dictionaryPayload];
//
//    // [ 测试代码 ] 接受VOIP推送中的payload内容进行具体业务逻辑处理
//    NSLog(@"[ TestDemo ] [ Voip Payload ]: %@, %@", payload, payload.dictionaryPayload);
//}


#pragma mark - GeTuiSdkDelegate

/// [ GTSDK回调 ] SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [ GTSDK ]：个推SDK已注册，返回clientId
    NSLog(@"[ TestDemo ] [GTSdk RegisterClient]:%@", clientId);
}

/// [ GTSDK回调 ] SDK收到透传消息回调
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSDK ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];

    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }

    // [ 测试代码 ] 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"[ TestDemo ] [GTSdk ReceivePayload]:%@\n\n", msg);
}

/// [ GTSDK回调 ] SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [ 测试代码 ] 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"[ TestDemo ] [GTSdk DidSendMessage]:%@ \n\n", msg);
}

/// [ GTSDK回调 ] SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [ 测试代码 ] 控制台打印日志，通知SDK运行状态
    NSLog(@"[ TestDemo ] [GTSdk SdkState]:%u \n\n", aStatus);
}

/// [ GTSDK回调 ] SDK设置推送模式回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    // [ 测试代码 ] 控制台打印日志
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }

    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

#pragma mark - bugly
- (void)registerBugly{
    [Bugly startWithAppId:@"d91b4ca720"       ];
}

@end
