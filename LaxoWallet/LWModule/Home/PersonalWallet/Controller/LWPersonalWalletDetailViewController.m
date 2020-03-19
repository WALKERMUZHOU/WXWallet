//
//  LWPersonalWalletDetailViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersonalWalletDetailViewController.h"
#import "LWPersoanDetailListView.h"

@interface LWPersonalWalletDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@end

@implementation LWPersonalWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)createUI{
    self.receiveBtn.layer.borderColor = [UIColor hex:@"#D8D8D8"].CGColor;
    self.sendBtn.layer.borderColor = [UIColor hex:@"#D8D8D8"].CGColor;
    
    UIBarButtonItem *addBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_wallet_qrcode"] style:UIBarButtonItemStylePlain target:self action:@selector(qrClick)];
//    self.navigationItem.leftBarButtonItem = addBarItem;
       
    UIBarButtonItem *scanBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_scan_white"] style:UIBarButtonItemStylePlain target:self action:@selector(scanClick)];
    self.navigationItem.rightBarButtonItems = @[scanBarItem,addBarItem];
    
    LWPersoanDetailListView *listView = [[LWPersoanDetailListView alloc]initWithFrame:CGRectMake(0, 262, kScreenWidth, KScreenHeightBar - 262) style:UITableViewStyleGrouped];
    listView.walletId = self.contentModel.walletId;
    [self.view addSubview:listView];
    [listView getCurrentData];
    

}

- (IBAction)eyeClick:(UIButton *)sender {

}

- (IBAction)recevieClick:(UIButton *)sender {
}

- (IBAction)sendClick:(UIButton *)sender {
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
