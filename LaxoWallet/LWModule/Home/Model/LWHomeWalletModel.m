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
    NSArray *partiesArray = [dic objectForKey:@"parties"];
    NSInteger unJoin = 0;
    if (partiesArray.count > 0) {
        NSMutableArray *partyMutabArray = [NSMutableArray array];
        for (NSInteger i = 0; i<partiesArray.count; i++) {
            LWPartiesModel *model = [LWPartiesModel modelWithDictionary:partiesArray[i]];
            [partyMutabArray addObj:model];
            if (model.status == 0) {
                unJoin++;
            }
        }
        
        self.parties = partyMutabArray;
        self.needToJoinCount = unJoin;
    }
    
    CGFloat bitCount = 0;
    for (NSInteger i = 0; i<self.utxo.count; i++) {
        LWutxoModel *model = [self.utxo objectAtIndex:i];
        bitCount += model.value;
    }
    self.personalBitCount = bitCount/1e8;
    self.personalBitCurrency = [LWPublicManager getCurrentPriceWithTokenType:TokenTypeBSV].floatValue * bitCount/1e8;
    return YES;
}

@end
