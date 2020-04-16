//
//  LWHistoryPaymailModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWHistoryPaymailModel : LWBaseModel

@property (nonatomic, strong) NSString *paymail;
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
