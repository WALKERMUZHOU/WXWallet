//
//  LWMineCurrencyViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineCurrencyViewController.h"
#import "LWMineSettingLanguageView.h"
#import "LWBaseTableView.h"
#import "LWMineSettingLanguageCell.h"
#import "LWCurrencyModel.h"
#import "LWCurrencyListView.h"

@interface LWMineCurrencyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) LWBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray    *datasource;
@end

@implementation LWMineCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LWCurrencyListView *listView = [[LWCurrencyListView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:listView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
