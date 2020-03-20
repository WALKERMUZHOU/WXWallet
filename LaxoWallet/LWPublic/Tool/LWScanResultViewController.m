//
//  LWScanResultViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWScanResultViewController.h"

@interface LWScanResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation LWScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel.text = self.contentStr;
    // Do any additional setup after loading the view from its nib.
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
