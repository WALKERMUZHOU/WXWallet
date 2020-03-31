//
//  LWCurrencyModel.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/30.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWCurrencyModel : LWBaseModel

@property (nonatomic, strong) NSString  *title;
///statue == 1选中 statue other 没选中
@property (nonatomic, assign) NSInteger statue;

@end

NS_ASSUME_NONNULL_END
