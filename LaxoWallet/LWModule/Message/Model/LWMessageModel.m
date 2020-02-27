//
//  LWMessageModel.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMessageModel.h"

@implementation LWMessageModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"messageId":@"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    if ([[dic objectForKey:@"status"] integerValue] == 1) {
        self.viewHeight= 290;
    }else if ([[dic objectForKey:@"status"] integerValue] == 2){
        if ([[dic objectForKey:@"type"] integerValue] == 1) {
            self.viewHeight = 270;
        }else{
            self.viewHeight = 245;
        }
    }
    NSArray *partiesArray = [dic objectForKey:@"parties"];
    if (partiesArray.count>0) {
        self.parties = [NSArray modelArrayWithClass:[LWPartiesModel class] json:partiesArray];
    }
    
    return YES;
}

@end
