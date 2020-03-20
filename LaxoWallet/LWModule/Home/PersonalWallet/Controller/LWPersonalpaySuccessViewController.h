//
//  LWPersonalpaySuccessViewController.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWPersonalpaySuccessViewController : LWBaseViewController
///viewtypy == 1 多人钱包
@property (nonatomic, assign) NSInteger viewType;
- (void)setSuccessWithAmount:(NSString *)amount andaddress:(NSString *)address andnote:(NSString *)note andfee:(NSString *)fee;
@end

NS_ASSUME_NONNULL_END
