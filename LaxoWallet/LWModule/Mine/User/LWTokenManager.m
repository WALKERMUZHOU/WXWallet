//
//  LWTokenManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWTokenManager.h"

@implementation LWTokenManager

+ (NSString *)getCurrentPriceWithTokenType:(TokenType)tokenType{
    NSString *tokenName;
    switch (tokenType) {
         case TokenTypeBSV:
            tokenName = @"bsv";
             break;
        case TokenTypeBitCoin:
            tokenName = @"bitCoin";
                break;
             
         default:
             break;
     }
    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAppTokenPrice_userdefault"];
    for (NSInteger i = 0; i<dataArray.count; i++) {
        NSDictionary *tokenDic = [dataArray objectAtIndex:i];
        if ([[tokenDic objectForKey:@"token"] isEqualToString:tokenName]) {
            return [tokenDic objectForKey:@"cny"];
        }
    }
    return @"";
}

@end
