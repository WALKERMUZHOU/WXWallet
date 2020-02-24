//
//  LWTokenManager.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, TokenType){
    TokenTypeBSV = 1,
    TokenTypeBitCoin = 2,
};
@interface LWTokenManager : NSObject

+ (NSString *)getCurrentPriceWithTokenType:(TokenType)tokenType;


@end

NS_ASSUME_NONNULL_END
