//
//  LWInputTextField.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, LWInputTextFieldType){
    LWInputTextFieldTypeNormal = 1,
    LWInputTextFieldTypeleftSelect = 2,
    LWInputTextFieldTypeRightBtn = 3,
};

typedef void(^ButtonClickBlock)(void);
@interface LWInputTextField : UIView

- (instancetype)initWithFrame:(CGRect)frame andType:(LWInputTextFieldType)textFieldType;
@property (nonatomic, strong) UITextField *lwTextField;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) ButtonClickBlock buttonBlock;

@end

NS_ASSUME_NONNULL_END
