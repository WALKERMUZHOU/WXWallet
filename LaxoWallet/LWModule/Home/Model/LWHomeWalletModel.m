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
    NSString *name = [dic ds_stringForKey:@"name"];
    if (!name || name.length == 0) {
        self.name = @"BSV";
    }
    
    NSString *walletuid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
    self.uid = walletuid;
    
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
    CGFloat canuseCount = 0;
    CGFloat lockCount = 0;
    for (NSInteger i = 0; i<self.utxo.count; i++) {
        LWutxoModel *model = [self.utxo objectAtIndex:i];
        bitCount += model.value;
        if (model.status == 1) {
            canuseCount += model.value;
        }else{
            lockCount += model.value;
        }
        
    }
    self.personalBitCount = bitCount/1e8;
    self.canuseBitCount = canuseCount/1e8;
    self.loackBitCount = lockCount/1e8;
    
    self.canuseBitCountInterger = canuseCount;
    self.loackBitCountInterger = lockCount;
    
    self.personalBitCurrency = [LWPublicManager getCurrentPriceWithTokenType:TokenTypeBSV].floatValue * bitCount/1e8;
    
    self.personalBitUSDCurrency = [LWPublicManager getCurrentUSDPrice].floatValue *bitCount/1e8;
    
    if([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY){
        self.personalPrice = [NSString stringWithFormat:@"¥ %.2f",self.personalBitCurrency];
    }else{
        self.personalPrice = [NSString stringWithFormat:@"$ %.2f",self.personalBitCurrency];
    }
    
    
    NSString *uid = [[LWUserManager shareInstance] getUserModel].uid;
    NSString *walletUid = [NSString stringWithFormat:@"%@", [dic objectForKey:@"uid"]];
    if (uid.intValue == walletUid.intValue) {
        self.isMineCreateWallet = YES;
    }
    
    return YES;
}

@end
