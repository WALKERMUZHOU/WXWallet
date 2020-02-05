//
//  CZRefreshFooter.m
//  duoshoubang
//
//  Created by zmm on 16/7/29.
//  Copyright © 2016年 vanwell. All rights reserved.
//

#import "CZRefreshFooter.h"
@interface CZRefreshFooter()

@property (nonatomic, strong) UIView    *nomoreDataView;

@end
@implementation CZRefreshFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepare{
    [super prepare];
    
}


- (void)placeSubviews{
    [super placeSubviews];
    if (self.state == MJRefreshStateNoMoreData) {
        self.stateLabel.text = @"";
        if (!self.nomoreDataView) {
            self.nomoreDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            self.nomoreDataView.backgroundColor = [UIColor clearColor];
            [self addSubview:self.nomoreDataView];
            self.nomoreDataView.kcenterY = self.kheight/2;
            
            UILabel *label = [[UILabel alloc]initWithFrame:self.nomoreDataView.bounds];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"别拉了,到底了";
            label.font = kFont(13);
            label.textColor = UIColorFromRGB(kColorPureBlack);
            [self.nomoreDataView addSubview:label];
            if (self.normoreDataStr) {
                label.text = self.normoreDataStr;
            }
            
            UIView *leftLine = [[UIView alloc]init];
            leftLine.backgroundColor = UIColorFromRGB(kColorPureBlack);
            [self.nomoreDataView addSubview:leftLine];
            
            UIView *rightLine = [[UIView alloc]init];
            rightLine.backgroundColor = UIColorFromRGB(kColorPureBlack);
            [self.nomoreDataView addSubview:rightLine];
            
            [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(12);
                make.right.equalTo(self.mas_centerX).offset(-50);
                make.height.equalTo(@0.5);
                make.centerY.mas_equalTo(self.nomoreDataView.mas_centerY);
            }];
            
            [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-12);
                make.left.equalTo(self.mas_centerX).offset(50);
                make.height.equalTo(@0.5);
                make.centerY.mas_equalTo(self.nomoreDataView.mas_centerY);
            }];
            
        }
    }else{
        if (self.nomoreDataView) {
            [self.nomoreDataView removeFromSuperview];
            self.nomoreDataView = nil;
        }
    }
}

@end
