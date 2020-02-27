//
//  LWMessageMulpityHeadView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageMulpityHeadView.h"
#import "LWMessageImageTitleButton.h"
#import "LWMessageDeleteUserViewController.h"

@interface LWMessageMulpityHeadView ()
@property (nonatomic, strong) LWHomeWalletModel *model;
@property (nonatomic, strong) NSArray *partyArray;

@end

@implementation LWMessageMulpityHeadView

- (instancetype)initWithFrame:(CGRect)frame andModel:(nonnull LWHomeWalletModel *)partiesModel andParties:(nonnull NSArray *)parties{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = partiesModel;
        self.partyArray = [NSArray modelArrayWithClass:[LWPartiesModel class] json:parties];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    CGFloat preleftWidth = 18;
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat gapWidth = (kScreenWidth - 50)/6/2;
    CGFloat buttonWidth = (kScreenWidth - gapWidth*2)/5;
    CGFloat buttonHeight = (100+73-20)/2;
    CGFloat topHeight = 0;
    for (NSInteger i = 0; i<self.partyArray.count; i++) {
        LWMessageImageTitleButton *button = [[LWMessageImageTitleButton alloc] initWithFrame:CGRectMake(gapWidth + buttonWidth * (i%5), 10 + (buttonHeight + 10) *(i/5), buttonWidth, buttonHeight)];
        button.tag = 11000+i;
        [self addSubview:button];
        LWPartiesModel *model = [self.partyArray objectAtIndex:i];
        [button setImage:nil andTitle:model.user];
//        if (i == self.partyArray.count) {
//            button.isDeleteBtn = YES;
//            button.clickBlock = ^{
//                [self buttonClick:i];
//            };
//        }else if (i == self.partyArray.count + 1){
//            button.isAddBtn = YES;
//            button.clickBlock = ^{
//                [self buttonClick:i];
//            };
//        }else{
//            LWPartiesModel *model = [self.partyArray objectAtIndex:i];
//            [button setImage:@"" andTitle:model.user];
//        }
    }
    topHeight = (10 + buttonHeight) * ((self.partyArray.count+2)/5 + 1) + 5;
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(preleftWidth, topHeight, 200, 25)];
    [balanceLabel setFont:kFont(17.5)];
    [balanceLabel setTextColor:lwColorBlack];
    balanceLabel.text = [NSString stringWithFormat:@"余额：%@",@(_model.personalBitCurrency).description];
    [self addSubview:balanceLabel];
    topHeight += (25 + 30);
    
    UILabel *walletNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(preleftWidth, topHeight, 200, 17)];
    [walletNameLabel setFont:kFont(12.5)];
    [walletNameLabel setTextColor:lwColorBlack2];
    walletNameLabel.text = [NSString stringWithFormat:@"钱包名称：%@",_model.name];
    [self addSubview:walletNameLabel];
    
    UILabel *createNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(preleftWidth + kScreenWidth/2, topHeight, 200, 17)];
    [createNameLabel setFont:kFont(12.5)];
    [createNameLabel setTextColor:lwColorBlack2];
    createNameLabel.text = @"创建人：";
    [self addSubview:createNameLabel];
    
    topHeight += (17+15);
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(preleftWidth, topHeight, 200, 17)];
    [timeLabel setFont:kFont(12.5)];
    [timeLabel setTextColor:lwColorBlack2];
    timeLabel.text = @"创建时间：";
    [self addSubview:timeLabel];
    self.viewHeight = topHeight + 17 + 10;
}

- (void)buttonClick:(NSInteger)index{
    if (index == self.partyArray.count) {
        LWMessageDeleteUserViewController *deleteVC = [[LWMessageDeleteUserViewController alloc] init];
        [LogicHandle pushViewController:deleteVC];
        
    }else if (index == self.partyArray.count + 1){

    }
}

- (void)showWithViewController:(UIViewController *)viewController{
    BOOL isfirstLaunch = YES;
    for (UIView *view in viewController.view.subviews) {
        if ([view isKindOfClass:[LWMessageMulpityHeadView class]]) {
            isfirstLaunch = NO;
        }
    }
    if (isfirstLaunch) {
        self.frame = CGRectMake(0, -self.viewHeight, kScreenWidth, self.viewHeight);
        self.hidden = YES;
        self.alpha = 0;
        [viewController.view addSubview:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
       self.frame = CGRectMake(0,kNavigationBarHeight, kScreenWidth, self.viewHeight);
        self.hidden = NO;
        self.alpha = 1;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, -self.viewHeight, kScreenWidth, self.viewHeight);
        self.hidden = YES;
        self.alpha = 0;
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
