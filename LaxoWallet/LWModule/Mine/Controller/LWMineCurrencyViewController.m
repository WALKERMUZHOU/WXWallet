//
//  LWMineCurrencyViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineCurrencyViewController.h"
#import "LWMineSettingLanguageView.h"
@interface LWMineCurrencyViewController ()

@end

@implementation LWMineCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.MineVCType == 3){
        LWMineSettingLanguageView *securtyView = [[LWMineSettingLanguageView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        securtyView.viewType = 1;
        [self.view addSubview:securtyView];
    }else if (self.MineVCType == 4){
        LWMineSettingLanguageView *securtyView = [[LWMineSettingLanguageView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        securtyView.viewType = 2;
        [self.view addSubview:securtyView];
    }
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
