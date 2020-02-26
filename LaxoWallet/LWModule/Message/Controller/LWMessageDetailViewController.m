//
//  LWMessageDetailViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageDetailViewController.h"
#import "LWMessageMulpityHeadView.h"

@interface LWMessageDetailViewController ()
@property (nonatomic, strong) LWMessageMulpityHeadView *headView;

@end

@implementation LWMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = lwColorBackground;
    
    self.headView = [[LWMessageMulpityHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) andParties:@[]];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"home_newWallet"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *items=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = items;
}

- (void)rightButtonClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.headView.frame = CGRectMake(0, -self.headView.viewHeight, kScreenWidth, self.headView.viewHeight);
        [self.headView showWithViewController:self];
    }else{
        [self.headView dismiss];
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
