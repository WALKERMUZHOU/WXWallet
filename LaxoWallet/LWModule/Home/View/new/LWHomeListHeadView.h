//
//  LWHomeListHeadView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWHomeListView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ListHeadBlock)(NSInteger selectIndex);
@interface LWHomeListHeadView : UIView

@property (nonatomic, assign) LWHomeListViewType currentViewType;
@property (nonatomic, copy) ListHeadBlock block;

- (void)setPersonalWalletdData:(NSDictionary *)personalDic;
- (void)setMultipyWalletdata:(NSDictionary *)multipyDic;

@end

NS_ASSUME_NONNULL_END
