//
//  LWUserModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWUserModel : LWBaseModel

@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSString      *uid;
@property (nonatomic, strong) NSString      *email;


@property (nonatomic, strong) NSString      *login_token;
@property (nonatomic, strong) NSString      *secret;
@property (nonatomic, strong) NSString      *token;

@property (nonatomic, strong) NSString      *loginSuccess;
@property (nonatomic, strong) NSString      *jiZhuCi;
@property (nonatomic, strong) NSString      *pk;

@property (nonatomic, strong) NSString      *dk;
@property (nonatomic, strong) NSString      *ek;

@property (nonatomic, assign) NSInteger     face_enable;
@property (nonatomic, strong) NSString      *face_token;

@property (nonatomic, strong) NSArray       *trusthold;


@end

NS_ASSUME_NONNULL_END
