//
//  LWScanTool.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWScanTool : NSObject

+ (void)startScan:(void(^)(id result))scanResult;

@end

NS_ASSUME_NONNULL_END
