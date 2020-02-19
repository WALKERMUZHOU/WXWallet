//
//  LWutxoModel.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWutxoModel.h"

@implementation LWutxoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"utxoId":@"id"};
}

@end
