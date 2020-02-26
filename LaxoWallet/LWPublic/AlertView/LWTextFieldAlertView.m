//
//  LWTextFieldAlertView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWTextFieldAlertView.h"
#define UIColorFromR_G_B(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface LWTextFieldAlertView ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *alertview;

@property (nonatomic,strong) UILabel *titleLabel;//打回
@property (nonatomic,strong) UITextField *textField;//输入评价内容

@property (nonatomic, copy) NSString *repulse_content_str;//输入评价内容

@property (nonatomic,strong) UIButton *cancelButton;//取消
@property (nonatomic,strong) UIButton *makeSureButton;//打回

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString  *placeHolderString;

@end

@implementation LWTextFieldAlertView

- (instancetype)initWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeholder{
    self = [super init];
    if (self) {
        self.titleString = title;
        self.placeHolderString = placeholder;
        self.frame = [UIScreen mainScreen].bounds;
        //        self.alertview.center = self.center;
        self.alertview.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.alertview];
        [self createYTStsrAlertView];
    }
    return self;
}

-(void)createYTStsrAlertView{
    CGFloat preleft = 16;

    CGFloat labelHeight = [self.titleString boundingRectWithSize:CGSizeMake(self.alertview.kwidth - preleft * 2, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(17.5)} context:nil].size.height;
    self.alertview.frame = CGRectMake(20, kFit(88) + (isIphoneX ? 88.0 : 64.0), kScreenWidth - 20 * 2, labelHeight + 210);

    self.titleLabel = [UILabel new];
    self.titleLabel.text = self.titleString;
    self.titleLabel.textColor = lwColorBlack;
    self.titleLabel.font = kFont(17.5);
    self.titleLabel.numberOfLines = 0;
    [self.alertview addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.alertview.mas_left).offset(preleft);
        make.right.equalTo(self.alertview.mas_right).offset(-preleft);
    }];

    //输入评价内容
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.font = kFont(20);
    self.textField.placeholder = self.placeHolderString;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 42)];
    UILabel *leftV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 42)];
    leftV.text = @"₿";
    leftV.font = kFont(15);
    leftV.textColor = lwColorBlack;
    leftV.textAlignment = NSTextAlignmentRight;
    [leftView addSubview:leftV];
    self.textField.leftView = leftView;   // 设置 TF 的 leftView 为 leftV
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.textColor = lwColorBlack;
    self.textField.font = kFont(15);
    self.textField.layer.cornerRadius = 2;
    self.textField.layer.borderColor = lwColorNormal.CGColor;
    self.textField.layer.borderWidth = 0.5f;
    [self.alertview addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
        make.left.offset(preleft);
        make.right.offset(-preleft);
        make.height.offset(42);
    }];

    UIView *breakLine = [[UIView alloc] init];
    breakLine.backgroundColor = lwColorGray97;
    [self.alertview addSubview:breakLine];
    [breakLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.alertview.mas_bottom).offset(-50);
        make.left.equalTo(self.alertview.mas_left);
        make.right.equalTo(self.alertview.mas_right);
        make.height.equalTo(@(0.5));
    }];
    
    UIView *breakLine1 = [[UIView alloc] init];
    breakLine1.backgroundColor = lwColorGray97;
    [self.alertview addSubview:breakLine1];
    [breakLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(breakLine.mas_bottom);
        make.bottom.equalTo(self.alertview.mas_bottom);
        make.centerX.equalTo(self.alertview.mas_centerX);
        make.width.equalTo(@(0.5));
    }];
    
    //取消
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:lwColorBlack forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = kMediumFont(17.5);
    [self.cancelButton addTarget:self action:@selector(evaluate_cancel_buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.alertview.mas_bottom);
        make.left.equalTo(self.alertview.mas_left);
        make.top.equalTo(breakLine.mas_bottom);
        make.right.equalTo(breakLine1.mas_left);
    }];
    
    //确定
    self.makeSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.makeSureButton setTitle:@"设置" forState:UIControlStateNormal];
    [self.makeSureButton setTitleColor:lwColorNormal forState:UIControlStateNormal];
    self.makeSureButton.titleLabel.font = kMediumFont(17.5);
    [self.makeSureButton addTarget:self action:@selector(evaluate_makeSure_buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:self.makeSureButton];
    [self.makeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.offset(0);
        make.top.equalTo(breakLine.mas_bottom);
        make.left.equalTo(breakLine1.mas_right);
    }];
    
    
}

#pragma mark -------->取消Action
-(void)evaluate_cancel_buttonAction{
    [self endEditing:YES];
    if (self.lwAlertViewCloseBlock) {
        self.lwAlertViewCloseBlock();
    }
    [self dismissAlertView];
}

#pragma mark -
#pragma mark -------->评价Action
-(void)evaluate_makeSure_buttonAction{
    [self endEditing:YES];
    if (self.lwAlertViewMakeSureBlock && self.textField.text >0) {
        NSString *nameStr = [NSString stringWithFormat:@"₿%@",self.textField.text];
        self.lwAlertViewMakeSureBlock(nameStr);
    }
    [self dismissAlertView];
}


#pragma mark - textFieldDelegate


#pragma mark -------->打回set方法
-(void)setlwAlertViewMakeSureBlock:(void (^)(NSString *))lwAlertViewMakeSureBlock{
    _lwAlertViewMakeSureBlock = lwAlertViewMakeSureBlock;
}

#pragma mark -------->取消set方法
-(void)setlwAlertViewCloseBlock:(void (^)(void))lwAlertViewCloseBlock{
    _lwAlertViewCloseBlock = lwAlertViewCloseBlock;
}

-(UIView *)alertview
{
    if (_alertview == nil) {
        _alertview = [[UIView alloc] init];
        _alertview.backgroundColor = [UIColor whiteColor];
        _alertview.layer.cornerRadius = 2.5;
        _alertview.layer.masksToBounds = YES;
        _alertview.userInteractionEnabled = YES;
    }
    return _alertview;
}

-(void)show
{
    self.backgroundColor = [UIColor clearColor];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertview.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = UIColorFromR_G_B(1, 1, 1, 0.5f);
        self.alertview.transform = transform;
        self.alertview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
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
