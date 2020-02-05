//
//  CZCategoryScrollView.h
//  CZCategoryScrollView
//
//  Created by 橙子 on 16/5/19.
//  Copyright © 2016年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CZPanGestureRecognizerDirection) {
    CZPanGestureRecognizerDirectionRight = 1 << 0,
    CZPanGestureRecognizerDirectionLeft  = 1 << 1,
};


@interface CZCategoryInnerLine : UIView

@property (nonatomic, assign) CGFloat distanceToCategoryScrollViewBottom;
@property (nonatomic, assign) CGFloat width;//宽度 默认是0.5;

/**
 *  画线时超过标题左右两边的长度,默认是5;
 */
@property (nonatomic, assign) CGFloat halfLengthMoreThanTitle;//长度

@end

@class CZCategoryScrollView;
@protocol CZCategoryScrollViewDelegate <NSObject>

- (void)categoryScrollView:(CZCategoryScrollView *)scrollView clickedIndex:(NSInteger)index;
                            
@end

@interface CZCategoryScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) id<CZCategoryScrollViewDelegate> delegate;
@property (nonatomic, weak) UIScrollView *followScrollView;
@property (nonatomic, assign) CZPanGestureRecognizerDirection panGestureRecoginzerDirection;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray   *imageLabelArray;//用于给title打标

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIFont  *font;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, assign) NSInteger maxTitleNumberPerPage;//默认是4
@property (nonatomic, assign) CGFloat preLeftWidth;
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, assign) BOOL showUpLine;
@property (nonatomic, strong) UIColor *upLineColor;
/**
 *  选中线
 */
@property (nonatomic, strong) CZCategoryInnerLine *selectedLine;

/**
 *  根据标题长度 只是用标题的宽度.开启时,maxTitleNumberPerPage无效
 */
@property (nonatomic, assign) BOOL autoCalculateTitleSize;
@property (nonatomic, strong) NSArray *preButtonWidthArray;//预设的buttonArray;

/**
 *  标题间的空间
 */
@property (nonatomic, assign) CGFloat titlesSpace;


- (void)setTitleArray:(NSArray *)titleArray followedScrollView:(UIScrollView *)followedScrollView;

//给title打标时用
- (void)setTitleArray:(NSArray *)titleArray andImageLabelArray:(NSArray *)imageLabelArray;
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index;
- (UIButton *)buttonAtIndex:(NSInteger)index;
@end
