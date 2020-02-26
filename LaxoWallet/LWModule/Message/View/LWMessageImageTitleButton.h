//
//  LWMessageImageTitleButton.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(void);
@interface LWMessageImageTitleButton : UIView

@property (nonatomic, copy) ClickBlock clickBlock;

- (void)setImage:(UIImage *)image andTitle:(NSString *)title;
@property (nonatomic, assign) BOOL isDeleteBtn;
@property (nonatomic, assign) BOOL isAddBtn;
@end

NS_ASSUME_NONNULL_END
