//
//  LWMultipyUserStatueViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyUserStatueViewController.h"
#import "LWSignStatueListView.h"

@interface LWMultipyUserStatueViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) LWSignStatueListView *listView;

@end

@implementation LWMultipyUserStatueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@\nKey share members",self.walletModel.name];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LWSignStatueListView *listView = [[LWSignStatueListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.backView.kheight) style:UITableViewStyleGrouped];
    [listView setSignessSatuteViewWithWalletModel:self.walletModel andMessageModel:nil];
    [self.backView addSubview:listView];
    listView.block = ^{

        
    };
    
    self.timeLabel.text = [LWTimeTool EngLishMonthWithTimeStamp:self.walletModel.createtime abbreviations:YES EnglishShortNameForDate:NO];
    
    
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
