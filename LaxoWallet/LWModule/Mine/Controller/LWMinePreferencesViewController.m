//
//  LWMinePreferencesViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMinePreferencesViewController.h"
#import "LWMineCurrencyViewController.h"
#import "LWMineLanguageViewController.h"
#import "NSBundle+AppLanguageSwitch.h"

@interface LWMinePreferencesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@end

@implementation LWMinePreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.currencyLabel.text = [LWPublicManager getCurrentCurrencyEnglishCode];

    
//    if( [LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY){
//        self.currencyLabel.text = @"CNY";
//    }else{
//        self.currencyLabel.text = @"USD";
//    }
    
    NSString *curLanguage = [NSBundle getCusLanguage];

  
    if ([curLanguage isEqualToString:@"zh-Hans"]){
        self.languageLabel.text = @"简体中文";
    }else{
        self.languageLabel.text = @"English";
    }
}

- (IBAction)currencyClick:(UIButton *)sender {
    
    LWMineCurrencyViewController *minevc = [[LWMineCurrencyViewController alloc] init];
    minevc.MineVCType = 3;
    [self.navigationController pushViewController:minevc animated:YES];
    
}
- (IBAction)languageClick:(UIButton *)sender {

    LWMineLanguageViewController *minevc = [[LWMineLanguageViewController alloc] init];
    [self.navigationController pushViewController:minevc animated:YES];
    
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
