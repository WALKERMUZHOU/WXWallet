//
//  LWHomeListHeaderView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListHeaderView.h"
#import "PopoverView.h"
#import "TYAlertController.h"
#import "LogicHandle.h"

@interface LWHomeListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end


@implementation LWHomeListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)walletSwitchClick:(UIButton *)sender {
    
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:nil message:nil];
    alertView.isManualDesign1 = YES;
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"个人钱包" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        if (sender.selected == NO) {
            return ;
        }
        sender.selected = NO;
        self.walletName.text = @"个人钱包";
        NSLog(@"%@",action.title);
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"多人控制钱包" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
        if (sender.selected == YES) {
            return ;
        }
        sender.selected = YES;
        self.walletName.text = @"多人控制钱包";

    }]];

    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [LogicHandle presentViewController:alertController animate:YES];
    
}



- (IBAction)rightClick:(UIButton *)sender {
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"home_newWallet"] title:@"新钱包" handler:^(PopoverAction *action) {
       }];
    PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"home_scan"] title:@"扫码" handler:^(PopoverAction *action) {
       }];
       
   PopoverView *popoverView = [PopoverView popoverView];
   popoverView.style = PopoverViewStyleDark;
   // 在没有系统控件的情况下调用可以使用显示在指定的点坐标的方法弹出菜单控件.
   [popoverView showToView:sender withActions:@[action1, action2]];
}

@end
