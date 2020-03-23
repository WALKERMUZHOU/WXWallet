//
//  LWPayMailViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPayMailViewController.h"
#import "LWPaymialListTableView.h"

@interface LWPayMailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ownedBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyNewBtn;
@property (weak, nonatomic) IBOutlet UIView   *coverView;

@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UITextField *payMailTF;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *payMailTFBackView;

@property (nonatomic, strong) LWPaymialListTableView *listView;

@end

@implementation LWPayMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.payMailTFBackView.layer.borderColor = lwColorGrayD8.CGColor;
    
    self.payMailTF.delegate = self;
    
    self.listView = [[LWPaymialListTableView alloc] initWithFrame:self.firstView.bounds style:UITableViewStyleGrouped];
    [self.firstView addSubview:self.listView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payMailEditResult:) name:kWebScoket_paymail_query object:nil];
}

- (IBAction)personBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    self.buyNewBtn.selected = NO;
    [self.buyNewBtn.titleLabel setFont:kFont(16)];
    [self.ownedBtn.titleLabel setFont:kBoldFont(16)];

    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(0, 0, 115, 40);
    }];

    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}

- (IBAction)buyNewBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
          return;
      }
    sender.selected = YES;
    self.ownedBtn.selected = NO;
    [self.buyNewBtn.titleLabel setFont:kBoldFont(16)];
    [self.ownedBtn.titleLabel setFont:kFont(16)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(115, 0, 115, 40);
    }];
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];

    
}
- (IBAction)buyClick:(UIButton *)sender {
}

#pragma mark - textfield
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        [self verifyPaymailAddress];
    }
}

- (void)verifyPaymailAddress{
    NSDictionary *params = @{@"name":[NSString stringWithFormat:@"%@@volt.io",self.payMailTF.text]};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestId_paymail_query),
                                            WS_paymail_query,
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    [[SocketRocketUtility instance] sendData:data];
}

- (void)payMailEditResult:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    if ([[notiDic objectForKey:@"success"] integerValue] == 1 ) {
        if (1) {
            self.statueLabel.text = @"Available!";
            self.statueLabel.textColor = lwColorNormal;
        }else{
            self.statueLabel.text = @"UnAvailable!";
            self.statueLabel.textColor = lwColorRedLight;
        }
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
