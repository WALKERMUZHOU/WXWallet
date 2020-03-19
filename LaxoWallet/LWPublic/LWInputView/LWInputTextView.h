//
//  LWInputTextView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LWInputEmailBlock)(NSArray *emailArray);
@interface LWInputTextView : UIView

@property (nonatomic, copy) LWInputEmailBlock emailBlock;
@property (nonatomic, assign) NSInteger maxEmailCount;

@end

NS_ASSUME_NONNULL_END
