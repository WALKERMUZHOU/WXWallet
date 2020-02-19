//
//  LWHomeListHeaderView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWHomeWalletModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^HeaderViewBlock)(NSInteger selectIndex);
@interface LWHomeListHeaderView : UIView

@property (nonatomic, copy) HeaderViewBlock headerBlock;

@property (nonatomic, assign) NSInteger currentType;
@property (nonatomic, strong) NSArray *currentArray;
@end

NS_ASSUME_NONNULL_END
