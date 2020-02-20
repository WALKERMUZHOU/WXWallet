//
//  LWBottomLineInputTextField.m
//  LaxoWallet
//
//  Created by bitmesh on 2020/2/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBottomLineInputTextField.h"
#import "QQLBXScanViewController.h"

@interface LWBottomLineInputTextField()

@property (nonatomic, assign) LWBottomLineInputTextFieldType currentType;

@property (nonatomic, strong) UILabel  *describeLabel;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UIButton *pasteButton;
@property (nonatomic, strong) UIView   *bottomLine;

@end

@implementation LWBottomLineInputTextField

- (instancetype)initWithFrame:(CGRect)frame andType:(LWBottomLineInputTextFieldType)textFieldType{
    self.currentType = textFieldType;
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self.currentType = LWBottomLineInputTextFieldTypeNormal;
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height)];
    [self addSubview:self.textField];
    
    self.describeLabel = [[UILabel alloc]init];
    self.describeLabel.font = kFont(14);
    self.describeLabel.textColor = lwColorGray2;
    [self addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.centerY.equalTo(self.mas_centerY);
    }];
 
    self.scanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.scanButton.tag = 10010;
    [self.scanButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scanButton setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
    [self addSubview:self.scanButton];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    
    self.pasteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.pasteButton.tag = 10011;
    [self.pasteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pasteButton setImage:[UIImage imageNamed:@"home_paste"] forState:UIControlStateNormal];
    [self addSubview:self.pasteButton];
    [self.pasteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scanButton.mas_left).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = lwColorGray3;
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    switch (self.currentType) {
        case LWBottomLineInputTextFieldTypeNormal:{
            self.describeLabel.hidden = YES;
            self.scanButton.hidden = YES;
            self.pasteButton.hidden = YES;
        }
            
            break;
        case LWBottomLineInputTextFieldTypeDescribe:{
            self.describeLabel.hidden = NO;
            self.scanButton.hidden = YES;
            self.pasteButton.hidden = YES;
        }
            
            break;
        case LWBottomLineInputTextFieldTypeButtons:{
            self.describeLabel.hidden = YES;
            self.scanButton.hidden = NO;
            self.pasteButton.hidden = NO;
        }
            
            break;
        default:
            break;
    }
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 10011) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
         if(pasteBoard.string && pasteBoard.string.length>0){
             self.textField.text = pasteBoard.string;
             [self.textField resignFirstResponder];
         }
        return;
    }else if (sender.tag == 10010){
        QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = SLT_ZXing;
    //       vc.scanCodeType = [Global sharedManager].scanCodeType;

        vc.style = [QQLBXScanViewController qqStyle];
        //镜头拉远拉近功能
        vc.isVideoZoom = YES;
        vc.modalPresentationStyle = 0;
        vc.scanresult = ^(LBXScanResult *result) {
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        [LogicHandle presentViewController:vc animate:YES];
    }
    
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag - 10010);
    }
}

- (void)setDescripStr:(NSString *)descripStr{
    self.describeLabel.text = descripStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
