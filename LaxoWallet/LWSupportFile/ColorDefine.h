//
//  ColorDefine.h
//  CQMServicePlatform
//
//  Created by yanbo on 2017/7/4.
//  Copyright © 2017年 yanbo. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h

#import "UIColor+BFKit.h"

#define kColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kColorRGB(r,g,b) kColorRGBA(r,g,b,1)

#define kColorSingleA(s,a) kColorRGBA(s,s,s,a)
#define kColorSingle(s) kColorSingleA(s,1)

#define kColorSVProgressBgColor kColorSingleA(255,0.8)

#define kCQMTintColorBlue [UIColor hex:@"#0076ff"]
#define kCQMTintDetailColorBlue [UIColor hex:@"#0095ff"]

#define kTextHeavyColor [UIColor hex:@"#333333"]
#define kTextMediumColor [UIColor hex:@"#666666"]
#define kTextLightColor [UIColor hex:@"#999999"]

#define kNavBarTintColor kCQMTintColorBlue
#define kNavTintColor [UIColor hex:@"#ffffff"]

#define kTabBarTintColor [UIColor hex:@"#FD6464"]
#define kTabBarBackGroundColor [UIColor hex:@"#FFFFFF"]
#define kTabBarShadowColor [UIColor colorWithColor:[UIColor hex:@"#0051FF"] alpha:0.06]

#define lwColorBackground   [UIColor hex:@"#F7F8FB"]

#define lwColorNormal       [UIColor hex:@"#2BB696"]
#define lwColorNormalLight  [UIColor hex:@"#AEEDDF"]

#define lwColorNormalDeep   [UIColor hex:@"#01424A"]

#define lwColorGray         [UIColor hex:@"#F3F3F3"]
#define lwColorGray1        [UIColor hex:@"#F1F1F1"]
#define lwColorGray2        [UIColor hex:@"#909499"]
#define lwColorGray3        [UIColor hex:@"#E1E1E1"]
#define lwColorGray9        [UIColor hex:@"#F9F9F9"]
#define lwColorGray97       [UIColor hex:@"#979797"]

#define lwColorGrayC1       [UIColor hex:@"#C1C1C1"]

#define lwColorBlack        [UIColor hex:@"#333333"]
#define lwColorBlackLight   [UIColor hex:@"#666666"]
#define lwColorBlackPure    [UIColor hex:@"#999999"]
#define lwColorBlack1       [UIColor hex:@"#666C72"]
#define lwColorBlack2       [UIColor hex:@"#3A3B42"]

#define lwColorWhite        [UIColor hex:@"#ffffff"]

#define lwColorLabel1       [UIColor hex:@"#666C72"]

#define lwColorPlacerHolder [UIColor hex:@"#8D8F90"]

#endif /* ColorDefine_h */
