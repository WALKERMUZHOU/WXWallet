//
//  LWMessageDetailListCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageDetailListCell.h"
#import "LWMessageDetailTitleContentView.h"
@interface LWMessageDetailListCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation LWMessageDetailListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.contentView.backgroundColor = lwColorBackground;
    
    CGFloat preleft = 32.5;
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, kScreenWidth - 36, 300)];
    self.backView.backgroundColor = lwColorWhite;
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.backView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(preleft, 8.5, 30, 30)];
    [self.iconImageView setImage:[UIImage imageNamed:@""]];
    [self.backView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.kright + 20, 0, 200, 30)];
    self.titleLabel.kcenterY = self.iconImageView.kcenterY;
    [self.titleLabel setFont:kFont(20)];
    [self.titleLabel setTextColor:lwColorBlack];
    self.titleLabel.text = @"转账";
    [self.backView addSubview:self.titleLabel];

    self.tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 8.5, 30, 30)];
    [self.tipImageView setImage:[UIImage imageNamed:@""]];
    self.tipImageView.kright = self.backView.kwidth - 30;
    [self.backView addSubview:self.tipImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, self.backView.kwidth, 1)];
    lineView.backgroundColor = lwColorGray0;
    [self.backView addSubview:lineView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(preleft, lineView.kbottom + 7.5, 200, 18)];
    [self.timeLabel setFont:kFont(12.5)];
    [self.timeLabel setTextColor:lwColorBlack];
    [self.backView addSubview:self.timeLabel];

    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.timeLabel.kbottom + 11.5, self.backView.kwidth, 38)];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.priceLabel setFont:kMediumFont(25)];
    [self.priceLabel setTextColor:lwColorBlack];
    [self.backView addSubview:self.priceLabel];
    
    for (NSInteger i = 0; i<4; i++) {
        LWMessageDetailTitleContentView *tcView = [[LWMessageDetailTitleContentView alloc] initWithFrame:CGRectMake(0, self.priceLabel.kbottom + 19 + i*(24+10), self.backView.kwidth, 24)];
        tcView.tag = 10100+i;
        [self.backView addSubview:tcView];
    }
    
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn.frame = CGRectMake(0, self.backView.kheight - 48, self.backView.kwidth, 48);
    [self.bottomBtn setTitle:@"签名" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:lwColorNormal forState:UIControlStateNormal];
    [self.bottomBtn.self.titleLabel setFont:kMediumFont(20)];
    [self.bottomBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bottomBtn ];
}

- (void)setModel:(LWMessageModel *)model{
    _model = model;
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [dateStringFormatter stringFromDate:_model.createtime];
    
    CGFloat currentCurrency = [LWPublicManager getCurrentPriceWithTokenType:TokenTypeBSV].floatValue;
    
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f(%@BSV)",currentCurrency * _model.value/1e8,@(_model.value/1e8)];
    NSString *txidStr = [_model.txid stringByReplacingCharactersInRange:NSMakeRange(2, _model.txid.length - 6) withString:@"***"];
    NSArray *infoArray;
    if (_model.status == 1) {//待签名
        self.titleLabel.text = @"待签名转账";
        self.iconImageView.image = [UIImage imageNamed:@"message_statue_waiting"];
        self.bottomBtn.hidden = NO;
    }else if (_model.status == 2){
        self.bottomBtn.hidden = YES;
        if (_model.type == 1) {//转出
            self.titleLabel.text = @"转账";
            self.iconImageView.image = [UIImage imageNamed:@"message_statue_transfer"];
            infoArray = @[@{@"title":@"收款方",@"content":@""},@{@"title":@"备注",@"content":_model.note},@{@"title":@"交易发起人",@"content":@""},@{@"title":@"TxID",@"content":txidStr},];
        }else{
            self.titleLabel.text = @"收款";
            self.iconImageView.image = [UIImage imageNamed:@"message_statue_gathering"];
            infoArray = @[@{@"title":@"发送方",@"content":@""},@{@"title":@"备注",@"content":_model.note},@{@"title":@"TxID",@"content":txidStr},];
        }
        for (NSInteger i = 0; i<4; i++) {
            LWMessageDetailTitleContentView *tcView = [self.backView viewWithTag:10100+i];
            if (i<infoArray.count) {
                tcView.hidden = NO;
                NSDictionary *infoDic = [infoArray objectAtIndex:i];

                [tcView setTitle:[infoDic objectForKey:@"title"] andContent:[infoDic objectForKey:@"content"] andIsShowTip:NO];
            }else{
                tcView.hidden = YES;
            }
        }
        

        
    }
    
}

- (void)backClick:(UIButton *)sender{
    
}
@end
