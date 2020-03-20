//
//  LWScanModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWScanModel : LWBaseModel
///scanType 1:扫描结果为btc二维码 2：登录  10000,未知
@property (nonatomic, assign) NSInteger scanType;
@property (nonatomic, strong) NSString *scanResult;

@end

NS_ASSUME_NONNULL_END
