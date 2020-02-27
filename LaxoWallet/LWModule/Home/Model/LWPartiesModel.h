//
//  LWPartiesModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWPartiesModel : LWBaseModel
@property (nonatomic, strong) NSString      *partiesId;
@property (nonatomic, strong) NSString      *uid;//钱包创建用户ID
@property (nonatomic, assign) NSInteger     status;//0-未加入 1-已加入
@property (nonatomic, assign) NSInteger     type;//1-个人钱包类型，2-多方钱包类型
@property (nonatomic, assign) NSInteger     role;//
@property (nonatomic, strong) NSString      *updatetime;//钱包更新时间
@property (nonatomic, strong) NSString      *createtime;//钱包创建时间
@property (nonatomic, strong) NSString      *user;
@end

NS_ASSUME_NONNULL_END
