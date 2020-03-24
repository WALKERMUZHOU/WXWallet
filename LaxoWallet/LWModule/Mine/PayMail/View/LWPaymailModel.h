//
//  LWPaymailModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/*
 createtime = 1585028889000;
 id = 9;
 main = 0;
 name = hhhhpay;
 status = 1;
 txid = "<null>";
 updatetime = 1585028889000;
 wid = 12;
 */

@interface LWPaymailModel : LWBaseModel

@property (nonatomic, strong) NSString *paymailId;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *updatetime;

@property (nonatomic, strong) NSString *txid;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger main;

@end

NS_ASSUME_NONNULL_END
