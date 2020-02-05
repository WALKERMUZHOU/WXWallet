
//
//  TYLScrollView.h
//  CircleScrollView
//
//  Created by 橙子 on 15/8/20.
//  Copyright (c) 2015年 橙子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ScrollViewBackImageType){
    ScrollViewBackImageTypeGoodsDetail = 1,
};
@class TYLScrollView;
@protocol TYLScrollViewDelegate <NSObject>

-(void)scrollView:(TYLScrollView *)scrollView didClickedAtPage:(NSInteger)pageIndex;

@end

@interface TYLScrollView : UIView

@property (nonatomic, strong)UIScrollView   *scrollView;
@property (nonatomic, strong)NSArray        *imageURLArray;
@property (nonatomic, weak)id<TYLScrollViewDelegate>delegate;
@property (nonatomic, assign) ScrollViewBackImageType   backImageType;


@end


