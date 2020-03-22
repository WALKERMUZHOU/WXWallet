//
//  LWMineSecurityViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineSecurityViewController.h"
#import "LWMineSecurityView.h"
#import "LWMineSettingView.h"
#import "LWMineSettingLanguageView.h"

@interface LWMineSecurityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation LWMineSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailLabel.text = [[LWUserManager shareInstance] getUserModel].email;
    
    return;
    if (self.MineVCType == 1) {
        self.title = @"Security";
        LWMineSecurityView *securtyView = [[LWMineSecurityView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:securtyView];
    }else if (self.MineVCType == 2){
        self.title = @"Setting";
        LWMineSettingView *securtyView = [[LWMineSettingView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:securtyView];
    }else if (self.MineVCType == 3){
        self.title = @"Currency";
        LWMineSettingLanguageView *securtyView = [[LWMineSettingLanguageView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        securtyView.viewType = 1;
        [self.view addSubview:securtyView];
    }else if (self.MineVCType == 4){
        self.title = @"Language";
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
