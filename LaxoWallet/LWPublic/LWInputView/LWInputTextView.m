//
//  LWInputTextView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWInputTextView.h"
#import "LWEmailBtn.h"
#import "LWEmailBtnView.h"
@interface LWInputTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView    *textView;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UILabel       *placeHolderView;

@property (nonatomic, strong) NSMutableArray       *emailArray;

@end

@implementation LWInputTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)initBasic{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor hex:@"#DBDBDB"].CGColor;
    self.layer.cornerRadius = 4;
//    self.backgroundColor = lwColorGray1;
}

- (void)createUI{
    
    [self initBasic];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 18.5, self.frame.size.width - 10*2, self.frame.size.height - 18.5) textContainer:nil];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.keyboardType = UIKeyboardTypeEmailAddress;
    [self addSubview:self.textView];
    
    self.placeHolderView = [[UILabel alloc] init];
    self.placeHolderView.textAlignment = NSTextAlignmentLeft;
    self.placeHolderView.numberOfLines = 0;
    self.placeHolderView.textColor = lwColorPlacerHolder;
    self.placeHolderView.text = @"please input all email IDs of other participants in order to successfully create a n/m multiparty account, new users have to register with same email to successfully join this account";
    [self addSubview:self.placeHolderView];
    [self.placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.textView);
    }];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 10*2, 20)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    
    UIButton *pasteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22.5, 22.5)];
    [pasteBtn addTarget:self action:@selector(pasteClick:) forControlEvents:UIControlEventTouchUpInside];
    [pasteBtn setBackgroundImage:[UIImage imageNamed:@"home_paste"] forState:UIControlStateNormal];
    [self addSubview:pasteBtn];
    pasteBtn.kright = self.frame.size.width -10;
    pasteBtn.kbottom = self.frame.size.height - 10;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.maxEmailCount == 0) {
        [WMHUDUntil showMessageToWindow:@"Please Input Total Members Holding Key Shares"];
        return NO;
    }
//    self.placeHolderView.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{

}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.emailArray.count == 0) {
        self.placeHolderView.hidden = NO;
    }
    [self manageCurrentTextView:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length>0) {
        self.placeHolderView.hidden = YES;
    }
    if ([text isEqualToString:@"\n"] || [text isEqualToString:@" "]) { // 输入回车
        NSLog(@"输入了h空格");
        [self manageCurrentTextView:textView];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
}

#pragma mark - method
- (void)manageCurrentTextView:(UITextView *)textView{
    if (self.emailArray.count  == self.maxEmailCount - 1) {
        self.textView.text = @"";
        return;
    }
    
    if (!self.emailArray) {
        self.emailArray = [NSMutableArray array];
    }
    if (textView.text.length == 0) return ;
    [self.emailArray addObject:textView.text];
    textView.text = @"";
    [self refrshCurrentButton];
}

- (void)refrshCurrentButton{
    [self.scrollView removeAllSubviews];
    CGFloat x = 0;
    CGFloat gapx = 10;
    CGFloat y = 5;
    CGFloat gapY = 7.5;
    CGFloat maxWidth = self.scrollView.frame.size.width;
    CGFloat btnHeight = 30;
    
    for (NSInteger i = 0; i<self.emailArray.count; i++) {
    
        LWEmailBtnView *emailBtn = [[LWEmailBtnView alloc] init];
        emailBtn.tag = 1000+i;

        emailBtn.block = ^{
            [self emailBtnClick:1000+i];
        };
        [emailBtn setViewTitle:self.emailArray[i]];
        [self.scrollView addSubview:emailBtn];
          CGFloat emailBtnWidth = [emailBtn getCurrentWidth];
          if ((x+emailBtnWidth) > maxWidth){
              x = 0;
              y += (btnHeight + gapY);
          }
//        emailBtn.kleft = x;
//        emailBtn.ktop = y;
          emailBtn.frame = CGRectMake(x, y, emailBtnWidth, btnHeight);
          x = (x+gapx+emailBtnWidth);
    }
    
    self.scrollView.frame = CGRectMake(10, 0, self.frame.size.width - 10*2, y + btnHeight + gapY);
    if (self.scrollView.frame.size.height > (210-25)) {
        self.scrollView.kheight = 185;
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width - 10*2, y + btnHeight + gapY);
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.scrollEnabled = YES;
    }
    self.textView.frame = CGRectMake(10, self.scrollView.kheight, self.frame.size.width - 10*2, 165-self.scrollView.kheight);
    self.placeHolderView.frame = CGRectMake(10, self.scrollView.kheight, self.frame.size.width - 10*2, 165-self.scrollView.kheight);
    
    if (self.emailBlock) {
        self.emailBlock(self.emailArray);
    }
}

- (void)pasteClick:(UIButton *)sender{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if(pasteBoard.string && pasteBoard.string.length>0){
        NSString *textViewText = self.textView.text;
        self.textView.text = [textViewText stringByAppendingString:pasteBoard.string];
        [self.textView resignFirstResponder];
    }
}

- (void)emailBtnClick:(NSInteger )senderIndex{
    NSInteger currentIndex = senderIndex - 1000;
    [self.emailArray removeObjectAtIndex:currentIndex];
    [self refrshCurrentButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
