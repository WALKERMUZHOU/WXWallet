//
//  LWMineSettingLanguageView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineSettingLanguageView.h"
#import "LWMineSettingLanguageCell.h"

@implementation LWMineSettingLanguageView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self setRefreshHeaderAndFooterNeeded:NO];
    
    UINib *nib1 = [UINib nibWithNibName:@"LWMineSettingLanguageCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWMineSettingLanguageCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.coordinator = [[LWHomeListCoordinator alloc]init];
//    self.coordinator.delegate = self;
//    _isCanApplyBorrow = YES;
 
}

- (void)setViewType:(NSInteger)viewType{
    _viewType = viewType;
    NSArray *array;
    if (viewType == 1) {
        array = @[@{@"title":@"CNY",@"type":@1},
                           @{@"title":@"USD",@"type":@1}
                           ];
    }else if (viewType == 2){
        array = @[@{@"title":@"中文",@"type":@2},
                           @{@"title":@"English",@"type":@2}
                           ];
    }
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *infoDic = [self.dataSource objectAtIndex:indexPath.row];
    NSInteger type = [[infoDic objectForKey:@"type"] integerValue];
    LWMineSettingLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWMineSettingLanguageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setInfoDic:infoDic];
    if (_viewType == 1) {
       LWCurrentCurrency currency = [LWPublicManager getCurrentCurrency];
        if (currency == LWCurrentCurrencyCNY) {
            if (indexPath.row == 0) {
                cell.isCellSelect = YES;
            }else{
                cell.isCellSelect = NO;
            }
        }else{
            if (indexPath.row == 1) {
                    cell.isCellSelect = YES;
            }else{
                cell.isCellSelect = NO;
            }
        }

    }else{
        LWCurrentLanguage language = [LWPublicManager getCurrentLanguage];
        if (indexPath.row == language-1) {
            cell.isCellSelect = YES;
        }else{
            cell.isCellSelect = NO;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewType == 1) {
       LWCurrentCurrency currency = [LWPublicManager getCurrentCurrency];
        if (indexPath.row+1 == currency) {
            return;
        }else{
            [LWPublicManager setCurrentCurrency:indexPath.row+1];
            [self.tableView reloadData];
        }
    }else{
        LWCurrentLanguage language = [LWPublicManager getCurrentLanguage];
        if (indexPath.row == language-1) {
            return;
        }else{
            [LWPublicManager setCurrentLanguage:indexPath.row + 1];
            [self.tableView reloadData];
        }
    }
}


@end
