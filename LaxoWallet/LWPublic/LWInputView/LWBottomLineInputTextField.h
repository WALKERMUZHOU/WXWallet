//
//  LWBottomLineInputTextField.h
//  LaxoWallet
//
//  Created by bitmesh on 2020/2/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, LWBottomLineInputTextFieldType){
    LWBottomLineInputTextFieldTypeNormal    = 1,
    LWBottomLineInputTextFieldTypeDescribe  = 2,
    LWBottomLineInputTextFieldTypeButtons   = 3,
};
typedef void(^ButtonClickBlock)(NSInteger index);

@interface LWBottomLineInputTextField : UIView

@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) NSString     *descripStr;
@property (nonatomic, copy) ButtonClickBlock buttonBlock;

- (instancetype)initWithFrame:(CGRect)frame andType:(LWBottomLineInputTextFieldType)textFieldType;

@end

NS_ASSUME_NONNULL_END
