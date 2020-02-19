//
//  LWHomeListModel.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeWalletModel.h"

@implementation LWHomeWalletModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"walletId":@"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    NSArray *utxoArray = [dic objectForKey:@"utxo"];
    self.utxo = [NSArray modelArrayWithClass:[LWutxoModel class] json:utxoArray];
    
    CGFloat bitCount = 0;
    for (NSInteger i = 0; i<self.utxo.count; i++) {
        LWutxoModel *model = [self.utxo objectAtIndex:i];
        bitCount += model.value;
    }
    self.personalBitCount = bitCount/1e8;
    
    return YES;
}

@end
