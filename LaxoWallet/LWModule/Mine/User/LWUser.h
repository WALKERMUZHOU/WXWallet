//
//  LWUser.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWUser : NSObject


@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSString      *uid;


@property (nonatomic, strong) NSString      *login_token;
@property (nonatomic, strong) NSString      *secret;
@property (nonatomic, strong) NSString      *token;


@end

NS_ASSUME_NONNULL_END
