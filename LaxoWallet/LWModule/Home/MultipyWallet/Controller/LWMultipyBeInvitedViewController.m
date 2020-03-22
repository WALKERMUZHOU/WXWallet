//
//  LWMultipyBeInvitedViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyBeInvitedViewController.h"

@interface LWMultipyBeInvitedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;

@end

@implementation LWMultipyBeInvitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.walletNameLabel.text = self.contentModel.name;
    for (NSInteger i = 0; i<self.contentModel.parties.count; i++) {
        LWPartiesModel *model = self.contentModel.parties[i];
        if ([model.uid isEqualToString:self.contentModel.uid]) {
            self.label1.text =[NSString stringWithFormat:@"You’ve been invited to join this wallet owned by %@. ",model.user];
            return;
        }
    }
    
    self.labelTwo.text =[NSString stringWithFormat:@"If you accept you’ll be a Key Share Member along with %ld others to assist in signing transactions.",(long)self.contentModel.parties.count];;
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
