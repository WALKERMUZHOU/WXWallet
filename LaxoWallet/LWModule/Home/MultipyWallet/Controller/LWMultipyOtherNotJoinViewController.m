//
//  LWMultipyOtherNotJoinViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyOtherNotJoinViewController.h"

@interface LWMultipyOtherNotJoinViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ownLabel;
@property (weak, nonatomic) IBOutlet UILabel *unJoinLabel;

@end

@implementation LWMultipyOtherNotJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i = 0; i<self.contentModel.parties.count; i++) {
        LWPartiesModel *model = self.contentModel.parties[i];
        
        if ([model.uid isEqualToString:self.contentModel.uid]) {
            self.ownLabel.text =  [NSString stringWithFormat:@"Owned by %@",model.user];
            break;
        }
    }
    NSInteger flag = 0;
    
    for (NSInteger i = 0; i<self.contentModel.parties.count; i++) {
        LWPartiesModel *model = self.contentModel.parties[i];
        if (model.status == 0) {
            flag ++;
        }
    }
    self.unJoinLabel.text = [NSString stringWithFormat:@"You’re a Key Share Member along with %ld others to assist in signing transactions.",(long)flag];
    
    
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
