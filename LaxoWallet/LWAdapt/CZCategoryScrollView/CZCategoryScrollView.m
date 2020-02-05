//
//  CZCategoryScrollView.m
//  CZCategoryScrollView
//
//  Created by 橙子 on 16/5/19.
//  Copyright © 2016年 orange. All rights reserved.
//
#import "CZCategoryScrollView.h"

#define kButtonImageWifth 20


@implementation CZCategoryInnerLine

- (instancetype)init {
    self = [super init];
    if (self) {
        _distanceToCategoryScrollViewBottom = 0;
        _width = 0.5;
        _halfLengthMoreThanTitle = 5;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end

@implementation CZCategoryScrollView {
    NSMutableArray *_buttonArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initObjects];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initObjects];
    }
    return self;
}

- (void)initObjects {
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    
    _buttonArray = [[NSMutableArray alloc]init];
    _maxTitleNumberPerPage = 4;
    _titlesSpace = 20.f;
    _preLeftWidth = 0;
    _selectedIndex = 0;
    _font = [UIFont systemFontOfSize:15];
    _titleColor = [UIColor blackColor];
    _selectedTitleColor = UIColorFromRGB(kColorNormalRed);
    _showBottomLine = NO;
    _bottomLineColor = UIColorFromRGB(kColorNormalRed);
    _showUpLine = NO;
    _upLineColor = [UIColor grayColor];
}

- (void)initButtons {
    
    if (!self.titleArray || self.titleArray.count == 0) {
        return;
    }else{
        for(UIView *view in self.scrollView.subviews){
            if (view != _selectedLine) {
                [view removeFromSuperview];
            }
        }
        [_buttonArray removeAllObjects];
    }
    for (NSInteger i = 0 ; i < [self.titleArray count]; i ++) {
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundColor:[UIColor whiteColor]];
        [_buttonArray addObject:button];
        [_scrollView addSubview:button];
       
    }
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [_scrollView setFrame:frame];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [_scrollView setBackgroundColor:backgroundColor];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self initButtons];
    [self layoutSubviews];
}

- (void)setTitle:(NSString *)title atIndex:(NSInteger)index {
    UIButton *button = [_buttonArray objectWithIndex:index];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
}

- (UIButton *)buttonAtIndex:(NSInteger)index {
    return [_buttonArray objectWithIndex:index];
}

- (void)setTitleArray:(NSArray *)titleArray andImageLabelArray:(NSArray *)imageLabelArray{
    _titleArray = titleArray;
    _imageLabelArray = imageLabelArray;
    [self initButtons];
    [self layoutSubviews];
}

- (void)setTitleArray:(NSArray *)titleArray followedScrollView:(UIScrollView *)followedScrollView
{
    [self setTitleArray:titleArray];
    [self setFollowScrollView:followedScrollView];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex > _selectedIndex) {
        _panGestureRecoginzerDirection = CZPanGestureRecognizerDirectionLeft;
    }else{
        _panGestureRecoginzerDirection = CZPanGestureRecognizerDirectionRight;
    }
    _selectedIndex = selectedIndex;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.followScrollView) {
            [self.followScrollView setContentOffset:CGPointMake(self.followScrollView.frame.size.width * _selectedIndex, 0) animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (NSInteger i = 0; i < _buttonArray.count; i ++) {
                    UIButton *button = [_buttonArray objectAtIndex:i];
                    if (i == _selectedIndex) {
                        [button setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
                    }else{
                        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
                    }
                }
            });
        }
    });
}

- (void)setSelectedLine:(CZCategoryInnerLine *)bottomLine {
    _selectedLine = bottomLine;
    [_scrollView addSubview:_selectedLine];
}

- (void)setFollowScrollView:(UIScrollView *)followScrollView {
    if (followScrollView) {
        [followScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }else {
        if (_followScrollView) {
            [_followScrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
    _followScrollView = followScrollView;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat originalX = self.preLeftWidth;
    for (NSInteger i = 0; i < _buttonArray.count; i ++) {
        UIButton *button = [_buttonArray objectAtIndex:i];
        NSObject *titleObject = [_titleArray objectAtIndex:i];
        [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        if ([titleObject isKindOfClass:[NSString class]]) {
            [button setTitle:(NSString *)titleObject forState:UIControlStateNormal];
        }else if ([titleObject isKindOfClass:[NSAttributedString class]]) {
            [button setAttributedTitle:(NSAttributedString *)titleObject forState:UIControlStateNormal];
        }
        [button.titleLabel setFont:self.font];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        
        CGFloat buttonWitdh = 0;
        if (_autoCalculateTitleSize) {
            if ([titleObject isKindOfClass:[NSString class]]) {
                buttonWitdh = [(NSString *)titleObject boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size.width + _titlesSpace;
            }else if ([titleObject isKindOfClass:[NSAttributedString class]]) {
                buttonWitdh = [(NSAttributedString *)titleObject boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading context:nil].size.width + _titlesSpace;
            }
            if (self.preButtonWidthArray) {
                NSNumber *preButtonWidth = [self.preButtonWidthArray objectWithIndex:i];
                if (preButtonWidth && preButtonWidth.doubleValue > 0) {
                    buttonWitdh = preButtonWidth.doubleValue;
                }
            }
            [button setFrame:CGRectMake(originalX , 2, buttonWitdh - _titlesSpace, _scrollView.frame.size.height - 4)];
            if (i == _buttonArray.count - 1) {
                originalX += (buttonWitdh - _titlesSpace);
            }else{
                originalX += buttonWitdh;
            }
        }else {
            buttonWitdh = (self.frame.size.width - self.preLeftWidth * 2)/_maxTitleNumberPerPage;
            [button setFrame:CGRectMake(originalX , 2, buttonWitdh, _scrollView.frame.size.height - 4)];
            originalX += buttonWitdh;
        }
        
        if (i< _imageLabelArray.count) {
            NSString *imageUrlString = [_imageLabelArray objectAtIndex:i];
            if (![imageUrlString isEqualToString:@""]) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(buttonWitdh - kButtonImageWifth-10, -1, kButtonImageWifth, kButtonImageWifth)];
                imageView.backgroundColor = [UIColor clearColor];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
                [button addSubview:imageView];
                [button bringSubviewToFront:imageView];
            }
        }
        
        if (i == _selectedIndex && !_selectedLine.hidden) {
            CGSize buttonOneTitleSize = [button.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_font} context:nil].size;
            [_selectedLine setFrame:CGRectMake(button.frame.origin.x + (button.frame.size.width - buttonOneTitleSize.width)/2 - _selectedLine.halfLengthMoreThanTitle, self.frame.size.height - _selectedLine.width - _selectedLine.distanceToCategoryScrollViewBottom, buttonOneTitleSize.width + _selectedLine.halfLengthMoreThanTitle * 2, _selectedLine.width)];
            [_selectedLine setNeedsLayout];
        }
        
        if (i == _selectedIndex) {
            [button setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
        }

    }
    [_scrollView bringSubviewToFront:_selectedLine];
    [self.scrollView setContentSize:CGSizeMake(originalX + self.preLeftWidth, _scrollView.frame.size.height)];
    //画底线和顶部线
    if (self.showBottomLine || self.showUpLine) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
            CGFloat lineWidth = 1;
            CGContextRef ref = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(ref, lineWidth);
            if (self.showUpLine) {
                [self.upLineColor setStroke];
                CGContextMoveToPoint(ref, 0, 0);
                CGContextAddLineToPoint(ref, self.frame.size.width, 0);
                CGContextStrokePath(ref);
            }
            if (self.showBottomLine) {
                [self.bottomLineColor setStroke];
                CGContextMoveToPoint(ref, 0, self.frame.size.height);
                CGContextAddLineToPoint(ref, self.frame.size.width, self.frame.size.height);
                [self.bottomLineColor setStroke];
                CGContextStrokePath(ref);
            }
            UIImage *lineImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scrollView.layer.contents = (id)lineImage.CGImage;
            });
        });
    }
}

#pragma mark - Others
- (void)onButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag;
    if (index > _selectedIndex) {
        _panGestureRecoginzerDirection = CZPanGestureRecognizerDirectionLeft;
    }else{
        _panGestureRecoginzerDirection = CZPanGestureRecognizerDirectionRight;
    }
    if(!self.followScrollView){
        
        UIButton *buttonOne = [_buttonArray objectAtIndex:index];
        CGSize buttonOneTitleSize = [buttonOne.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_font} context:nil].size;
        [UIView animateWithDuration:0.25 animations:^{
            _selectedLine.frame = CGRectMake(buttonOne.frame.origin.x + (buttonOne.frame.size.width - buttonOneTitleSize.width)/2, self.frame.size.height - _selectedLine.width - _selectedLine.distanceToCategoryScrollViewBottom, buttonOneTitleSize.width, _selectedLine.width);
        }];
    }
    
    
    _selectedIndex = index;
    [self.followScrollView setContentOffset:CGPointMake(self.followScrollView.contentSize.width * _selectedIndex/_buttonArray.count, 0) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < _buttonArray.count; i ++) {
            UIButton *button = [_buttonArray objectAtIndex:i];
            if (i == _selectedIndex) {
                [button setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
            }else{
                [button setTitleColor:self.titleColor forState:UIControlStateNormal];
            }
        }
    });
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryScrollView:clickedIndex:)]) {
        [self.delegate categoryScrollView:self clickedIndex:_selectedIndex];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && self.followScrollView) {
        
        if (!_buttonArray || _buttonArray.count == 0) {
            return;
        }
        CGPoint currentFollowScrollOffset = [(NSValue *)[change objectForKey:@"new"] CGPointValue];
        int pageNumber = self.followScrollView.contentOffset.x/self.followScrollView.frame.size.width;
        _selectedIndex = pageNumber;
        //颜色跟随
        CGFloat titleRed,titleGreen,titleBlue,titleAlpha;
        [self.titleColor getRed:&titleRed green:&titleGreen blue:&titleBlue alpha:&titleAlpha];
        CGFloat selectedTitleRed,selectedTitleGreen,selectedTitleBlue,selectedTitleAlpha;
        [self.selectedTitleColor getRed:&selectedTitleRed green:&selectedTitleGreen blue:&selectedTitleBlue alpha:&selectedTitleAlpha];
        
        if (self.followScrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint translatedPoint = [self.followScrollView.panGestureRecognizer translationInView:self.followScrollView];
            if (translatedPoint.x > 0) {//右滑
                _panGestureRecoginzerDirection = CZPanGestureRecognizerDirectionRight;
            }else{//左滑
                _panGestureRecoginzerDirection = CZPanGestureRecognizerDirectionLeft;
            }
        }
        
        CGFloat selectedLineWidth = 0;
        CGFloat selectedLineOraginX = 0;
        if (_panGestureRecoginzerDirection == CZPanGestureRecognizerDirectionLeft) {
            if (pageNumber >= _buttonArray.count - 1) {
                UIButton *lastButton = [_buttonArray lastObject];
                if (lastButton) {
                    selectedLineWidth = lastButton.frame.size.width + self.selectedLine.halfLengthMoreThanTitle *2;
                    selectedLineOraginX = lastButton.frame.origin.x - self.selectedLine.halfLengthMoreThanTitle + ([self getRemainderFromNumer:currentFollowScrollOffset.x byNumber:self.followScrollView.frame.size.width]/self.followScrollView.frame.size.width) * selectedLineWidth;
                }
            }else {
                //titleColor
                UIButton *leftButton = [_buttonArray objectAtIndex:pageNumber];
                //selectedLineWidth = leftButton.frame.size.width + self.selectedLine.halfLengthMoreThanTitle *2;
                UIButton *rightButton = [_buttonArray objectAtIndex:pageNumber + 1];

                if ([self getRemainderFromNumer:self.followScrollView.contentOffset.x byNumber:self.followScrollView.frame.size.width] >= self.followScrollView.frame.size.width/2) {
                    [leftButton setTitleColor:self.titleColor forState:UIControlStateNormal];
                    leftButton.selected = NO;
                    [rightButton setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
                    if ([rightButton titleForState:UIControlStateSelected] || [rightButton imageForState:UIControlStateSelected]) {
                        rightButton.selected = YES;
                    }
                }else{
                    [leftButton setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
                    if ([leftButton titleForState:UIControlStateSelected] || [leftButton imageForState:UIControlStateSelected]) {
                        leftButton.selected = YES;
                    }
                    [rightButton setTitleColor:self.titleColor forState:UIControlStateNormal];
                    rightButton.selected = NO;
                }
                //bottomLine
                selectedLineOraginX = leftButton.frame.origin.x + (rightButton.frame.origin.x - leftButton.frame.origin.x) * ([self getRemainderFromNumer:currentFollowScrollOffset.x byNumber:self.followScrollView.frame.size.width]/self.followScrollView.frame.size.width) - self.selectedLine.halfLengthMoreThanTitle;
                
                selectedLineWidth = self.selectedLine.halfLengthMoreThanTitle * 2 + leftButton.frame.size.width + (rightButton.frame.size.width - leftButton.frame.size.width) * ([self getRemainderFromNumer:currentFollowScrollOffset.x byNumber:self.followScrollView.frame.size.width]/self.followScrollView.frame.size.width);
            }
        }else{
            if (pageNumber >= 0 && self.followScrollView.contentOffset.x > 0) {
                UIButton *leftButton = [_buttonArray objectAtIndex:pageNumber];
                //titleColor
             
                selectedLineOraginX = leftButton.frame.origin.x - self.selectedLine.halfLengthMoreThanTitle;
                selectedLineWidth = leftButton.frame.size.width + self.selectedLine.halfLengthMoreThanTitle *2;
                if (pageNumber + 1 < _buttonArray.count) {
                    UIButton *rightButton = [_buttonArray objectAtIndex:pageNumber + 1];
                    
                    if ([self getRemainderFromNumer:self.followScrollView.contentOffset.x byNumber:self.followScrollView.frame.size.width] >= self.followScrollView.frame.size.width/2) {
                        [leftButton setTitleColor:self.titleColor forState:UIControlStateNormal];
                        leftButton.selected = NO;
                        [rightButton setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
                        if ([rightButton titleForState:UIControlStateSelected] || [leftButton imageForState:UIControlStateSelected]) {
                            rightButton.selected = YES;
                        }
                    }else{
                        [leftButton setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
                        if ([leftButton titleForState:UIControlStateSelected] || [leftButton imageForState:UIControlStateSelected]) {
                            leftButton.selected = YES;
                        }
                        [rightButton setTitleColor:self.titleColor forState:UIControlStateNormal];
                        rightButton.selected = NO;
                    }
                    
                    //bottomLine
                    selectedLineOraginX = rightButton.frame.origin.x - (rightButton.frame.origin.x - leftButton.frame.origin.x) * (1 - [self getRemainderFromNumer:currentFollowScrollOffset.x byNumber:self.followScrollView.frame.size.width]/self.followScrollView.frame.size.width) - self.selectedLine.halfLengthMoreThanTitle;
                    
                    selectedLineWidth = self.selectedLine.halfLengthMoreThanTitle * 2 + rightButton.frame.size.width + (leftButton.frame.size.width - rightButton.frame.size.width) * (1 - [self getRemainderFromNumer:self.followScrollView.contentOffset.x byNumber:self.followScrollView.frame.size.width] / self.followScrollView.frame.size.width);
                }
            }else{
                UIButton *firstButton = [_buttonArray objectAtIndex:0];
                if (firstButton) {
                    selectedLineWidth = firstButton.frame.size.width + self.selectedLine.halfLengthMoreThanTitle * 2;
                    selectedLineOraginX = firstButton.frame.origin.x - self.selectedLine.halfLengthMoreThanTitle + selectedLineWidth * (currentFollowScrollOffset.x/self.followScrollView.frame.size.width);
                    
                }
            }
        }
        //底部选中线跟随
        if (self.selectedLine && self.selectedLine.hidden == NO) {
            CGRect selectedLineFrame = self.selectedLine.frame;
            selectedLineFrame.origin.x = selectedLineOraginX;
            selectedLineFrame.size.width = selectedLineWidth;
            [self.selectedLine setFrame:selectedLineFrame];
        }
        
        //title位置跟随
        if (self.scrollView.contentSize.width > self.scrollView.frame.size.width) {
            UIButton *currentButton =  [_buttonArray objectAtIndex:pageNumber];
            if (currentButton) {
                CGFloat scrollCenter = selectedLineOraginX + selectedLineWidth/2;
                if (scrollCenter >= self.frame.size.width/2 && scrollCenter <= self.scrollView.contentSize.width - self.frame.size.width/2) {
                    [_scrollView setContentOffset:CGPointMake(scrollCenter - self.frame.size.width/2, 0)];
                }else if (scrollCenter < self.frame.size.width/2) {
                    [_scrollView setContentOffset:CGPointZero];
                }else{
                    [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - self.frame.size.width, 0)];
                }
            }
        }
    }
}

- (CGFloat)getOppositeDifferenceFromCurrentValue:(CGFloat)current futureValue:(CGFloat)futureValue {
    return fabs((current - futureValue) * (1 - [self getRemainderFromNumer:self.followScrollView.contentOffset.x byNumber:self.followScrollView.frame.size.width] / self.followScrollView.frame.size.width));
}

- (CGFloat)getDifferenceFromCurrentValue:(CGFloat)current futureValue:(CGFloat)futureValue {
    return fabs((current - futureValue) * ([self getRemainderFromNumer:self.followScrollView.contentOffset.x byNumber:self.followScrollView.frame.size.width] / self.followScrollView.frame.size.width));
}

//对float求余
- (CGFloat)getRemainderFromNumer:(CGFloat)father byNumber:(CGFloat)son{
    int count = father/son;
    return father - son*count;
}

- (void)dealloc {
    self.followScrollView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/



@end
