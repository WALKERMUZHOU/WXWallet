//
//  LWNetWorkSessionManager.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWNetWorkSessionManager : AFHTTPSessionManager

+ (LWNetWorkSessionManager *)shareInstance;

/**
 * 清掉header中的accessToken
 */
- (void)clearAccessTokenForHeader;

- (void)setDeviceIdForHeader;
- (void)resetDeviceIdForHeader;
/**
 *  get请求
 *
 *  @param path       url路径
 *  @param parameters 参数
 *  @param block      block
 */
- (NSURLSessionDataTask *)getPath:(NSString *)path parameters:(NSDictionary *)parameters withBlock:(void (^)(NSDictionary *result, NSError *error))block;

- (NSURLSessionDataTask *)getPath:(NSString *)path parameters:(NSDictionary *)parameters noAccesstoken:(BOOL)isNoAccesstoken withBlock:(void (^)(NSDictionary *result, NSError *error))block;

/**
 *  post请求
 *
 *  @param path       url路径
 *  @param parameters 参数
 *  @param block      block
 */
- (NSURLSessionDataTask *)postPath:(NSString *)path parameters:(NSDictionary *)parameters withBlock:(void (^)(NSDictionary *result, NSError *error))block;

- (NSURLSessionDataTask *)postPath:(NSString *)path parameters:(NSDictionary *)parameters noAccesstoken:(BOOL)isNoAccesstoken withBlock:(void (^)(NSDictionary *result, NSError *error))block;

/**
 *  post请求
 *
 *  @param path       url路径
 *  @param parameters 参数
 *  @param block      block
 */
//- (NSURLSessionDataTask *)syncPostPath:(NSString *)path parameters:(NSDictionary *)parameters withBlock:(void (^)(NSDictionary *result, NSError *error))block;

#pragma mark - NetworkReachability
// 开始检测网络状态
- (void)startMonitoring;
// 停止检测网络状态
- (void)stopMonitoring;
// 是否可以连接网络
@property (nonatomic, assign, readonly) BOOL netWorkAbility;

#pragma mark - 设置超时
@property (nonatomic, assign) NSTimeInterval timeoutInterval;   // 默认30秒

@end

NS_ASSUME_NONNULL_END
