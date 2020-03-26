//
//  LWTransactionModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWTransactionModel : LWBaseModel

@property (nonatomic, strong) NSString *transAmount;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *payMail;
@property (nonatomic, strong) NSString *changeAddress;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *fee;

@end

NS_ASSUME_NONNULL_END
