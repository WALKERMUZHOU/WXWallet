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
#import "iCloudHandle.h"
@interface LWMineSecurityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *icloudSyncBtn;

@end

@implementation LWMineSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
    self.emailLabel.text = userModel.email;
    
    NSString *ecryptResult = [iCloudHandle getKeyValueICloudStoreWithKey:userModel.email];
    if (ecryptResult && ecryptResult.length >0) {
        self.icloudSyncBtn.hidden = YES;
    }

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
- (IBAction)scynClick:(UIButton *)sender {
    
    [SVProgressHUD show];
    
    NSString *ecryptResult = [LWPublicManager getRecoverQRCodeStr];

    [iCloudHandle setUpKeyValueICloudStoreWithKey:[[LWUserManager shareInstance] getUserModel].email value:ecryptResult];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        self.icloudSyncBtn.hidden = YES;
        [WMHUDUntil showMessageToWindow:@"Sync Success"];
    });
    
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
