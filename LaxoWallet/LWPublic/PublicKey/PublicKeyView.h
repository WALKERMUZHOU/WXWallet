//
//  PublicKeyView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/11.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublicKeyView : UIView

+ (instancetype)shareInstance;
- (void)getInitDataBlock:(void(^)(NSDictionary *dicData))successBlock;
- (void)getOtherData:(NSString *)methodSte andBlock:(void(^)(NSDictionary *dicData))successBlock;

@end

NS_ASSUME_NONNULL_END
