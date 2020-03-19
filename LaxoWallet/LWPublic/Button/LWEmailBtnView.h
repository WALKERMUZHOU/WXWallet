//
//  LWEmailBtnView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EmailBtnBlock)(void);
@interface LWEmailBtnView : UIView

@property (nonatomic, strong) NSString *viewTitle;
@property (nonatomic, copy) EmailBtnBlock block;

- (CGFloat)getCurrentWidth;


@end

NS_ASSUME_NONNULL_END
