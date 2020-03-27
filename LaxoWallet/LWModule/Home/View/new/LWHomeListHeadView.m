//
//  LWHomeListHeadView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/17.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeListHeadView.h"
#import "LWHomeWalletModel.h"
#import "LWNumberTool.h"

@interface LWHomeListHeadView ()

@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *multipyBtn;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (nonatomic, strong) NSArray   *personalDataArray;
@property (nonatomic, strong) NSArray   *multipyDataArray;

@end


@implementation LWHomeListHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.currentViewType = LWHomeListViewTypePersonalWallet;
    self.personalBtn.selected = YES;
    self.multipyBtn.selected = NO;
    [self.multipyBtn.titleLabel setFont:kFont(16)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentCurrency) name:kCuurentCurrencyChange_nsnotification object:nil];
}


- (IBAction)personBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    self.multipyBtn.selected = NO;
    [self.multipyBtn.titleLabel setFont:kFont(16)];
    [self.personalBtn.titleLabel setFont:kBoldFont(16)];

    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(0, 0, 115, 40);
    }];
    [self setCurrentArray:self.personalDataArray];
    if (self.block) {
        self.block(LWHomeListViewTypePersonalWallet);
    }
}

- (IBAction)multipyBtnClick:(UIButton *)sender {
    if (sender.isSelected) {
          return;
      }
    sender.selected = YES;
    self.personalBtn.selected = NO;
    [self.multipyBtn.titleLabel setFont:kBoldFont(16)];
    [self.personalBtn.titleLabel setFont:kFont(16)];
    
    [self setCurrentArray:self.multipyDataArray];
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.frame = CGRectMake(115, 0, 115, 40);
    }];
    if (self.block) {
        self.block(LWHomeListViewTypeMultipyWallet);
    }
}
- (IBAction)lalalCLick:(UIButton *)sender {
    
}

- (IBAction)eyeClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.bitCountLabel.text = @"***";
        self.priceLabel.text = @"***";
    }else{
        if (self.currentViewType == LWHomeListViewTypePersonalWallet) {
            [self setCurrentArray:self.personalDataArray];
        }else{
            [self setCurrentArray:self.multipyDataArray];
        }
    }
}

#pragma mark - method
- (void)setPersonalWalletdData:(NSDictionary *)personalDic{
    NSArray *dataArray = [personalDic objectForKey:@"data"];
    if (dataArray.count>0) {
        self.personalDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:dataArray];
        if (self.currentViewType == LWHomeListViewTypePersonalWallet) {
            [self setCurrentArray:self.personalDataArray];
        }
    }
}

- (void)setMultipyWalletdata:(NSDictionary *)multipyDic{
    NSArray *dataArray = [multipyDic objectForKey:@"data"];
    if (dataArray.count>0) {
        self.multipyDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:dataArray];
        if (self.currentViewType == LWHomeListViewTypeMultipyWallet) {
            [self setCurrentArray:self.multipyDataArray];
        }
    }
}

- (void)setCurrentArray:(NSArray *)currentArray{
    if (currentArray.count == 0) {
        self.bitCountLabel.text = @"0";
        self.priceLabel.text = @"0";
        return;
    }
    
    CGFloat bitCount = 0;
    for (NSInteger i = 0; i<currentArray.count; i++) {
        LWHomeWalletModel *dataModel = [currentArray objectAtIndex:i];
        for (NSInteger j = 0; j<dataModel.utxo.count; j++) {
            LWutxoModel *umodel = [dataModel.utxo objectAtIndex:j];
            bitCount += umodel.value;
        }
    }
    self.bitCountLabel.text = [LWNumberTool formatSSSFloat:bitCount/1e8];
    
    NSArray *tokenArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAppTokenPrice_userdefault];
    if (tokenArray.count>0) {
        
        NSString *tokenPrice = [LWPublicManager getCurrentCurrencyPrice];
        CGFloat personalBitCount = [NSDecimalNumber decimalNumberWithString:tokenPrice].floatValue * bitCount/1e8;
        
        NSString *priceTypeStr = @"$";
        if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
            priceTypeStr = @"¥";
        }else{
            priceTypeStr = @"$";
        }
        
        self.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",priceTypeStr,personalBitCount];
    }
}

- (void)refreshCurrentCurrency{
    if (self.personalDataArray.count >0) {
        if (self.currentViewType == LWHomeListViewTypePersonalWallet) {
            [self setCurrentArray:self.personalDataArray];
        }else{
            [self setCurrentArray:self.multipyDataArray];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
