//
//  LWMessageModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"
#import "LWPartiesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMessageModel : LWBaseModel

@property (nonatomic, strong) NSString     *messageId;//id*
@property (nonatomic, strong) NSString     *uid;//用户id
@property (nonatomic, assign) NSInteger    type;//1-转入，2-转出
@property (nonatomic, assign) NSInteger    wid;//钱包id
@property (nonatomic, assign) CGFloat      value;//金额
@property (nonatomic, assign) CGFloat      fee;//手续费
@property (nonatomic, strong) NSString     *note;//备注
@property (nonatomic, strong) NSString     *txid;//texid
@property (nonatomic, strong) NSString     *price;//发出时的价格 usd为单位
@property (nonatomic, strong) NSString     *biz_data;

@property (nonatomic, assign) NSInteger      status;//状态1-待签名，2-完成，3-取消
@property (nonatomic, strong) NSDictionary     *user_status;//包含approve和reject
@property (nonatomic, strong) NSArray     *approve;//包含已签名用户uid的数组
@property (nonatomic, strong) NSArray     *reject;//包含已拒绝签名用户uid的数组
@property (nonatomic, strong) NSArray     *parties;//钱包成员数组，包含uid,user,approve,reject
@property (nonatomic, strong) NSString      *createtime;//创建时间

@property (nonatomic, assign) CGFloat     viewHeight;//高度

@property (nonatomic, assign) BOOL     isMineCreateTrans;


@end

NS_ASSUME_NONNULL_END
