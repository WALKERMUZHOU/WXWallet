//
//  LWHomeViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeViewController.h"
#import "LWHomeListView.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "PublicKeyView.h"

@interface LWHomeViewController ()

@end

@implementation LWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];

    [[PublicKeyView shareInstance] getInitDataBlock:^(NSDictionary * _Nonnull dicData) {
        NSLog(@"%@",dicData);
    }];
    // Do any additional setup after loading the view.

//    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)createUI{
    LWHomeListView *listView = [[LWHomeListView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
