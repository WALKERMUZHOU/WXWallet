//
//  LWHomeListModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"
#import "LWutxoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWHomeWalletModel : LWBaseModel

@property (nonatomic, assign) NSInteger     walletId;//钱包ID
@property (nonatomic, strong) NSString      *uid;//钱包创建用户ID
@property (nonatomic, strong) NSString      *name;//币种
@property (nonatomic, assign) NSInteger     type;//1-个人钱包类型，2-多方钱包类型
@property (nonatomic, strong) NSString      *token;
@property (nonatomic, assign) NSInteger     share;//多方个数
@property (nonatomic, assign) NSInteger     join;//0-未加入，1-已加入
@property (nonatomic, assign) NSInteger     threshold;//至少签名的多方个数
@property (nonatomic, assign) NSInteger     status;//状态0-创建中，1-已创建，2-已删除
@property (nonatomic, strong) NSString      *updatetime;//钱包更新时间
@property (nonatomic, strong) NSString      *createtime;//钱包创建时间

@property (nonatomic, strong) NSArray        *utxo;//钱包utxo数组
@property (nonatomic, strong) NSDictionary   *deposit;//收款地址对象

@property (nonatomic, assign) CGFloat       personalBitCount;
@property (nonatomic, assign) CGFloat       personalBitCurrency;

@property (nonatomic, strong) UIColor       *iconColor;
@property (nonatomic, strong) NSArray        *parties;//


@end

NS_ASSUME_NONNULL_END
