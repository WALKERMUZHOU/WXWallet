//
//  LWTrusteeModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/9.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWTrusteeModel : LWBaseModel
/*
 "id":1,
 "name":"bitmesh",
 "publicKey":"",
 "ek":""
 */
@property (nonatomic, strong) NSString      *trustId;


@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *publicKey;
@property (nonatomic, strong) NSString      *ek;

@end

NS_ASSUME_NONNULL_END
