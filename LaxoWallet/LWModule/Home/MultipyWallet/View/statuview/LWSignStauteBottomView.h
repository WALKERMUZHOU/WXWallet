//
//  LWSignStauteBottomView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BottomBlock)(void);
@interface LWSignStauteBottomView : LWBaseView

@property (nonatomic, copy) BottomBlock block;

@end

NS_ASSUME_NONNULL_END
