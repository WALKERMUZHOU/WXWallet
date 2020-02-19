//
//  LWHomeListView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, LWHomeListViewType){
    LWHomeListViewTypePersonalWallet = 1,
    LWHomeListViewTypeMultipyWallet = 2,
};
@interface LWHomeListView : LWBaseTableView

@property (nonatomic, assign) LWHomeListViewType currentViewType;

- (void)setPersonalWalletdData:(NSDictionary *)personalDic;
- (void)setMultipyWalletdata:(NSDictionary *)multipyDic;

@end

NS_ASSUME_NONNULL_END
