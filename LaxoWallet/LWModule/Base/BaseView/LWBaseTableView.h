//
//  LWBaseTableView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWBaseTableView : LWBaseView<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) UITableViewStyle tableViewStyle;//default is UITableViewStyleGrouped
@property (strong, nonatomic) UITableView *tableView; //Default listView is UITableView



#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end

NS_ASSUME_NONNULL_END
