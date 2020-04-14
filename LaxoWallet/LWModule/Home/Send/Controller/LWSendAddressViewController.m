//
//  LWSendAddressViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSendAddressViewController.h"

@interface LWSendAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIView *historyBackView;

@end

@implementation LWSendAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)nextClick:(UIButton *)sender {
}

- (IBAction)pasteClick:(UIButton *)sender {
}

- (IBAction)scanClick:(UIButton *)sender {
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
