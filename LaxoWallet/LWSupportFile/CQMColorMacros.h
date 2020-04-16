//
//  CQMColorMacros.h
//  CQMServicePlatform
//
//  Created by walkerman on 2017/7/20.
//  Copyright © 2017年 yanbo. All rights reserved.
//

#ifndef CQMColorMacros_h
#define CQMColorMacros_h
//RGB 与 UIColor 类的转换
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/*----------纯颜色-------------*/
#define kColorBlack                 0x333333    //最黑
#define kColorLightBlack            0x666666    //淡黑
#define kColorPureBlack             0x999999    //浅黑
#define kColorNoBlack               0xcccccc    //基本不是黑
#define kColorBackground            0xf5f5f5    //基础背景色
#define kColorBackgroundGray        0xeeeeee//背景灰

#define kColorShell                 0x56D4CD    //马甲包基色
#define kColorShellLight            0xB1E8DA    //马甲包基色浅色
/**
 以后作为基本色使用
 */
#define kColorNormalRed             0XFD6464   //基本红色

#define kColorBlue                  0x3895FF
#define kColorOrange                0xff9600
#define kColorGreen                 0x44DB5E
#define kCOlorRed                   0xFE2851
#define kColorGrey                  0xd8d8d8

#define kColorLightBlue             0x87BBFF

/*-----------背景-------------*/
#define kColorBackgroundRed          0xfffad3
#define kColorBackgroundDeepGray     0xe6e6e6//背景灰
#define kColorBackgroundLightGray    0xf6f6f6//背景色浅灰
#define kColorBackgroundWhite        0xffffff//背景白

/*-----------string----------*/
#define kColorStringGray             0x999999

#define kColorStringRed              0xf62531
#define kColorStringBlack            0x444444
#define kColorStringBlackDeep        0x333333
#define kcolorStringLightGray        0xcccccc
#define kColorStringOrange           0xffaf46

/*-----------button----------*/
#define kColorButtonBlue             0x3599ff
#define kColorButtonRed              0xff5461
#define kColorButtonBlackDeep        0x333333

/*-----------line------------*/
#define kColorLine                   0xEDF0F3
#define kColorLineBlack              0x333333
#define kColorLineLightBlack         0x4d4d4d
#define kcolorLineLightGray          0xcccccc
#define kColorLineGray               0xdddddd
#define kColorLineGrayOrgin          0xe5e5e5   //原来的线用的灰色
#define kColorLineButtonGray         0xdddddd//按钮灰色描边


#define kFont(fontValue)         [UIFont fontWithName:@"Roboto-Regular" size:fontValue]

#define kBoldFont(fontValue)     [UIFont fontWithName:@"Roboto-Bold" size:fontValue]
#define kSemBoldFont(fontValue) [UIFont systemFontOfSize:fontValue weight:UIFontWeightSemibold]
#define kMediumFont(fontValue) [UIFont fontWithName:@"Roboto-Medium" size:fontValue]

#define kAttributeText(string,fontValue) [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:fontValue]}]
#define kAttributeMediumText(string,fontValue) [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:fontValue]}]
#define kAttributeBoldText(string,fontValue) [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Bold" size:fontValue]}]

#endif /* CQMColorMacros_h */
