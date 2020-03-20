//
//  LWPersonalpaySuccessViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalpaySuccessViewController.h"

@interface LWPersonalpaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *successDescribeLabe;


@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end

@implementation LWPersonalpaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)setSuccessWithAmount:(NSString *)amount andaddress:(NSString *)address andnote:(NSString *)note andfee:(NSString *)fee{

    NSString *addressStr = [NSString stringWithFormat:@"Sent %@BSV to %@",amount,address];
    self.feeLabel.text = [NSString stringWithFormat:@"Network fee %@ BSV",fee];
    self.noteLabel.text = note;
    NSString *amountStr = [NSString stringWithFormat:@"%@BSV",amount];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:addressStr attributes:@{NSFontAttributeName:kFont(12),NSForegroundColorAttributeName:[UIColor colorWithColor:[UIColor blackColor] alpha:0.5]}];
    [attribute addAttributes:@{NSFontAttributeName:kBoldFont(12),NSForegroundColorAttributeName:[UIColor blackColor]} range:[amountStr rangeOfString:address]];
    [self.amountLabel setAttributedText:attribute];
    
    if (self.viewType == 1) {
        self.iconImageView.image
        = [UIImage imageNamed:@"home_wallet_success_m"];
        self.successDescribeLabe.text = @"Transaction signed by you";
        addressStr = [NSString stringWithFormat:@"You’re requesting members to sign for a successful transaction of %@BSV to be sent to %@",amount,address];
        amountStr = [NSString stringWithFormat:@"%@BSV",amount];
        attribute = [[NSMutableAttributedString alloc] initWithString:addressStr attributes:@{NSFontAttributeName:kFont(12),NSForegroundColorAttributeName:[UIColor colorWithColor:[UIColor blackColor] alpha:0.5]}];
        [attribute addAttributes:@{NSFontAttributeName:kBoldFont(12),NSForegroundColorAttributeName:[UIColor blackColor]} range:[amountStr rangeOfString:address]];
        [self.amountLabel setAttributedText:attribute];
    }
    
    
}

- (IBAction)closeClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
