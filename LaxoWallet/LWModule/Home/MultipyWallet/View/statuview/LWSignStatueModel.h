//
//  LWSignStatueModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWSignStatueModel : LWBaseModel
@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL  isOnLine;
@property (nonatomic, assign) NSInteger currentStatue;

@end

NS_ASSUME_NONNULL_END
