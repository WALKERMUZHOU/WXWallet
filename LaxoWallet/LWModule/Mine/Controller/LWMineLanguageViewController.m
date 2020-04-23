//
//  LWMineLanguageViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/30.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineLanguageViewController.h"
#import "NSBundle+AppLanguageSwitch.h"

@interface LWMineLanguageViewController ()

@end

@implementation LWMineLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *curLanguage = [NSBundle getCusLanguage];
    NSInteger tag = 0;
    if ([curLanguage isEqualToString:@"zh-Hans"] ) {
        tag = 13001;
    }else  if ([curLanguage isEqualToString:@"ja"] ) {
           tag = 13002;
    }else{
        tag = 13000;
    }
    
    for (NSInteger i = 0; i<2; i++) {
        UIView *view = [self.view viewWithTag:13000+i];
        if(tag == i+13000){
            view.hidden = NO;
        }else{
            view.hidden = YES;
        }
    }
    
    
}

- (IBAction)btnClick:(UIButton *)sender {
    NSString *curLanguage = [NSBundle getCusLanguage];

    switch (sender.tag) {
        case 14000:{
            if ([curLanguage isEqualToString:@"en"]) return;
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Change Language to English" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVProgressHUD show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NSBundle setCusLanguage:@"en"];
                    [SVProgressHUD dismiss];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];

        }
            break;
            
        case 14001:{
            if ([curLanguage isEqualToString:@"zh-Hans"]) return;

            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"改变语言为中文" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [SVProgressHUD show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NSBundle setCusLanguage:@"zh-Hans"];
                    [SVProgressHUD dismiss];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
            
        case 14002:{
            if ([curLanguage isEqualToString:@"ja"]) return;

            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"言語を日本語に変える" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [SVProgressHUD show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NSBundle setCusLanguage:@"ja"];
                    [SVProgressHUD dismiss];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
        default:
            break;
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
