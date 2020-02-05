//
//  LWBaseTableView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"

@implementation LWBaseTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        _tableViewStyle = UITableViewStyleGrouped;
        [self initTableViewWithStyle:_tableViewStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tableViewStyle = UITableViewStyleGrouped;
        [self initTableViewWithStyle:_tableViewStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        _tableViewStyle = style;
        [self initTableViewWithStyle:_tableViewStyle];
    }
    return self;
}

- (void)initTableViewWithStyle:(UITableViewStyle)style {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:style];
    [_tableView setBackgroundColor:UIColorFromRGB(kColorBackground)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = UIColorFromRGB(kColorBackgroundLightGray);
    [self addSubview:_tableView];
    [self addBackIcon];
}

- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        if (!_tableView) {
            [_tableView setFrame:self.bounds];
        }
    }
}

- (void)addBackIcon{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-23, -46-32, 46, 46)];
    [imageView setImage:[UIImage imageNamed:@"public_icon_background"]];
    [_tableView addSubview:imageView];
}

#pragma mark - coordinatorDelegate

- (void)coordinator:(LWBaseCoordinator *)coordinator data:(id)data {
    [super coordinator:coordinator data:data];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - setListView
- (UIScrollView *)getListView {
    return self.tableView;
}


@end
