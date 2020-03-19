//
//  LWPersonalSendViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalSendViewController.h"
#import "LWPersonalSendViewController.h"
#import "LWPersonalpaySuccessViewController.h"

#import "LWAlertTool.h"
@interface LWPersonalSendViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UILabel *amountDescribeLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteTF;

@end

@implementation LWPersonalSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.amountDescribeLabel.text = [NSString stringWithFormat:@"Available %@ / Locked in Pending TX %@",@(self.model.canuseBitCount),@(self.model.loackBitCount)];
    self.amountTF.delegate = self;
    
    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
         self.amountLabel.text = [NSString stringWithFormat:@"¥ 0"];
     }else{
         self.amountLabel.text = [NSString stringWithFormat:@"$ 0"];
     }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.amountLabel.text = [LWPublicManager getCurrentCurrencyPriceWithAmount:textField.text.floatValue];
}

- (IBAction)completeClick:(UIButton *)sender {
    if (!self.addressTF.text || self.addressTF.text.length == 0) {
        [WMHUDUntil showMessageToWindow:@"please input adress"];
        return;
    }
    
    if (!self.amountTF.text || self.amountTF.text.length == 0 || self.amountTF.text.floatValue == 0) {
        [WMHUDUntil showMessageToWindow:@"please input amount"];
        return;
    }
    
    if (self.amountTF.text.floatValue > self.model.canuseBitCount) {
        [WMHUDUntil showMessageToWindow:@"amount need less than available"];
        return;
    }
    [LWAlertTool alertPersonalWalletViewSend:self.model andAdress:self.addressTF.text andAmount:self.amountTF.text andNote:self.noteTF.text andComplete:^(void) {

    }];
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
