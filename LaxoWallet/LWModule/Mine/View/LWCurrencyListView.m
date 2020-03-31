//
//  LWCurrencyListView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/31.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWCurrencyListView.h"
#import "LWMineSettingLanguageCell.h"
#import "LWCurrencyModel.h"

@implementation LWCurrencyListView

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

    NSDictionary *currencyDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrencyToUSD_userdefault];

    NSArray *currencyArray = [self sortObjectsAccordingToInitialWith:currencyDic];

    if (currencyArray && currencyArray.count>0) {
        for (NSInteger i = 0; i<currencyArray.count; i++) {
            NSString *currentCurrency = [LWPublicManager getCurrentCurrencyEnglishCode];
            NSString *currency = currencyArray[i];
            
            LWCurrencyModel *model = [[LWCurrencyModel alloc] init];
            model.title = [currency uppercaseString];
            model.statue = 1;
            if ([currentCurrency isEqualToString:[currency uppercaseString]]) {
                model.statue = 2;
            }
            [self.dataSource addObj:model];
        }
    }
    [self.tableView reloadData];
}

-(NSMutableArray *)sortObjectsAccordingToInitialWith:(NSDictionary *)dic {

    NSArray *keyArray = dic.allKeys;
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return sortArray;
}


#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWCurrencyModel *infoDic = [self.dataSource objectAtIndex:indexPath.row];

    LWMineSettingLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWMineSettingLanguageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:infoDic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LWCurrencyModel *currentModel = [self.dataSource objectAtIndex:indexPath.row];
    NSString *currentCurrency = [LWPublicManager getCurrentCurrencyEnglishCode];
    NSString *currency = currentModel.title;
    if ([currentCurrency isEqualToString:[currency uppercaseString]]) {
        return;
    }
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        LWCurrencyModel *model = [self.dataSource objectAtIndex:i];
        if (i == indexPath.row) {
            model.statue = 2;
            [[NSNotificationCenter defaultCenter] postNotificationName:kCurrencyChange_nsnotification object:nil];
            [LWPublicManager setCurrentCurrencyEnglishCode:model.title];
        }else {
            model.statue = 1;
        }
    }

    [self.tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
