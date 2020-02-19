//
//  LWutxoModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWutxoModel : LWBaseModel

@property (nonatomic, strong) NSString *utxoId;
@property (nonatomic, strong) NSString *wid;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *vout;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *updatetime;


@end

NS_ASSUME_NONNULL_END
