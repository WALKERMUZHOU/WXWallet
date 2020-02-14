//
//  LWLoginViewController.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/12.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, LWLoginVCType){
    LWLoginVCTypeEmail = 1,
    LWLoginVCTypeCheckCode  = 2,
};

@interface LWLoginViewController : LWBaseViewController

@property (nonatomic, assign) LWLoginVCType loginVCType;

@end

NS_ASSUME_NONNULL_END
