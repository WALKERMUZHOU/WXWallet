//
//  LWHomeListHeaderView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListHeaderView.h"
#import "PopoverView.h"

@implementation LWHomeListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)walletSwitchClick:(UIButton *)sender {
}



- (IBAction)rightClick:(UIButton *)sender {
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"tab_home_sel"] title:@"新钱包" handler:^(PopoverAction *action) {
       }];
       PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"tab_home_sel"] title:@"扫码" handler:^(PopoverAction *action) {
       }];
       
       PopoverView *popoverView = [PopoverView popoverView];
       popoverView.style = PopoverViewStyleDark;
       // 在没有系统控件的情况下调用可以使用显示在指定的点坐标的方法弹出菜单控件.
       [popoverView showToView:sender withActions:@[action1, action2]];
}

@end
