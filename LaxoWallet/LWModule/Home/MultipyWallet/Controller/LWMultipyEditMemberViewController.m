//
//  LWMultipyEditMemberViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyEditMemberViewController.h"
#import "LWInputTextView.h"

@interface LWMultipyEditMemberViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) LWInputTextView   *emailTV;

@end

@implementation LWMultipyEditMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.emailTV = [[LWInputTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20*2, 260)];
    __weak typeof(self) weakself = self;
    self.emailTV.emailBlock = ^(NSArray * _Nonnull emailArray) {
//        weakself.emailArr = emailArray;
//        [weakSelf refreshLastCount];
    };
    self.emailTV.maxEmailCount =20;
    [self.backView addSubview:self.emailTV];
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
