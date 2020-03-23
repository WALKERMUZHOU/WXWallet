//
//  LWAssetInheritanceViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWAssetInheritanceViewController.h"

@interface LWAssetInheritanceViewController ()
@property (weak, nonatomic) IBOutlet UIView *firstSuccessorView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UITextField *successorTF;

@property (weak, nonatomic) IBOutlet UITextField *timerTF;
@end

@implementation LWAssetInheritanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstSuccessorView.layer.borderColor = lwColorGrayD8.CGColor;
    self.timeView.layer.borderColor = lwColorGrayD8.CGColor;

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)createBtn:(UIButton *)sender {
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
