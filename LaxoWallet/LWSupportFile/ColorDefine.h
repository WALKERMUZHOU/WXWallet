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

#define lwColorBackground   [UIColor hex:@"#f5f5f5"]
#define lwColorNormal       [UIColor hex:@"#2BB696"]
#define lwColorGray         [UIColor hex:@"#F3F3F3"]

#define lwColorBlack        [UIColor hex:@"#333333"]
#define lwColorBlackLight   [UIColor hex:@"#666666"]
#define lwColorBlackPure    [UIColor hex:@"#999999"]
#define lwColorBlack1       [UIColor hex:@"#666C72"]

#define lwColorWhite [UIColor hex:@"#ffffff"]


#endif /* ColorDefine_h */
