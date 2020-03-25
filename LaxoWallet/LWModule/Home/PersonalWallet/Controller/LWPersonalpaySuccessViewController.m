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

@property (nonatomic, strong) NSString *amount;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *fee;
@end

@implementation LWPersonalpaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    
    NSString *addressStr = [NSString stringWithFormat:@"Sent %@BSV to %@",self.amount,self.address];
    self.feeLabel.text = [NSString stringWithFormat:@"Network fee %@ BSV",self.fee];
    self.noteLabel.text = self.note;
    NSString *amountStr = [NSString stringWithFormat:@"%@BSV",self.amount];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:addressStr attributes:@{NSFontAttributeName:kFont(12),NSForegroundColorAttributeName:[UIColor colorWithColor:[UIColor blackColor] alpha:0.5]}];
    [attribute addAttributes:@{NSFontAttributeName:kBoldFont(12),NSForegroundColorAttributeName:[UIColor blackColor]} range:[amountStr rangeOfString:self.address]];
    [self.amountLabel setAttributedText:attribute];
    
    if (self.viewType == 1) {
        self.iconImageView.image
        = [UIImage imageNamed:@"home_wallet_success_m"];
        self.successDescribeLabe.text = @"Transaction signed by you";
        addressStr = [NSString stringWithFormat:@"You’re requesting members to sign for a successful transaction of %@BSV to be sent to %@",self.amount,self.address];
        amountStr = [NSString stringWithFormat:@"%@BSV",self.amount];
        attribute = [[NSMutableAttributedString alloc] initWithString:addressStr attributes:@{NSFontAttributeName:kFont(12),NSForegroundColorAttributeName:[UIColor colorWithColor:[UIColor blackColor] alpha:0.5]}];
        [attribute addAttributes:@{NSFontAttributeName:kBoldFont(12),NSForegroundColorAttributeName:[UIColor blackColor]} range:[amountStr rangeOfString:self.address]];
        [self.amountLabel setAttributedText:attribute];
    }
}

- (void)setSuccessWithAmount:(NSString *)amount andaddress:(NSString *)address andnote:(NSString *)note andfee:(NSString *)fee{

    self.amount = amount;
    self.address = address;
    self.note = [NSString stringWithFormat:@"note: %@",note];
    self.fee = [LWNumberTool formatSSSFloat:fee.floatValue];
    
    
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
