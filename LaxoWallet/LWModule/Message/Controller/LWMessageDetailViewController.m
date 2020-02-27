//
//  LWMessageDetailViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageDetailViewController.h"
#import "LWMessageDetailListView.h"
#import "LWMessageMulpityHeadView.h"
#import "LWMessageModel.h"

@interface LWMessageDetailViewController ()
@property (nonatomic, strong) LWMessageMulpityHeadView *headView;
@property (nonatomic, strong) LWMessageDetailListView *tableView;

@end

@implementation LWMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageMessagePartiesData:) name:kWebScoket_messageParties object:nil];
    
}

- (void)getCurrentParties{
    [SVProgressHUD show];
    NSDictionary *multipyparams = @{@"wid":@(self.contentModel.walletId)};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMessageParties),WS_Home_MessageParties,[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
}

- (void)createUI{
    self.view.backgroundColor = lwColorBackground;
        
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"home_newWallet"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *items=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = items;
    
    self.tableView = [[LWMessageDetailListView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.walletId = self.contentModel.walletId;
    [self.view addSubview:self.tableView];
    [self.tableView getCurrentData];
    
}

- (void)setContentModel:(LWHomeWalletModel *)contentModel{
    _contentModel = contentModel;
//    self.headView = [[LWMessageMulpityHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) andModel:contentModel];
}

#pragma mark - method
- (void)rightButtonClick:(UIButton *)sender{
    if (!self.headView) {
        [self getCurrentParties];
    }
    if (self.headView.isShow) {
        self.headView.isShow = NO;
        [self.headView dismiss];
    }else{
        self.headView.isShow = YES;
        [self.headView showWithViewController:self];
    }
//    sender.selected = !sender.isSelected;
//    if (sender.isSelected) {
//        self.headView.frame = CGRectMake(0, -self.headView.viewHeight, kScreenWidth, self.headView.viewHeight);
//        [self.headView showWithViewController:self];
//    }else{
//        [self.headView dismiss];
//    }
}

- (void)manageMessagePartiesData:(NSNotification *)notification{
    [SVProgressHUD dismiss];
    NSDictionary *requestInfo = notification.object;
    if ([[requestInfo objectForKey:@"success"]integerValue] == 1) {
        NSArray *dataArray = [requestInfo objectForKey:@"data"];
        if (!self.headView) {
            self.headView = [[LWMessageMulpityHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) andModel:_contentModel andParties:dataArray];
            self.headView.frame = CGRectMake(0, -self.headView.viewHeight, kScreenWidth, self.headView.viewHeight);
            self.headView.isShow = YES;
            [self.headView showWithViewController:self];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
