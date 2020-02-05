#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+SafeAccess.h"
#import "NSData+MD5.h"
#import "NSDictionary+SafeAccess.h"
#import "NSString+Attribute.h"
#import "NSString+Code.h"
#import "NSString+MD5.h"
#import "NSString+Size.h"
#import "NSUserDefaults+SafeAccess.h"
#import "UIButton+BackgroundColor.h"
#import "UIButton+DoubleClick.h"
#import "UIButton+frame.h"
#import "UIColor+RCColor.h"
#import "UIImage+Compress.h"
#import "UITextView+PlaceHolder.h"
#import "UIView+Frame.h"
#import "UIView+Operation.h"
#import "UIView+Toast.h"
#import "UIViewController+LifeCycle.h"

FOUNDATION_EXPORT double DSCategoriesVersionNumber;
FOUNDATION_EXPORT const unsigned char DSCategoriesVersionString[];

