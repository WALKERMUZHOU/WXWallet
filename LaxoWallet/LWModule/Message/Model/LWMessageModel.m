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
        self.viewHeight= 280;
    }else if ([[dic objectForKey:@"status"] integerValue] == 2){
        if ([[dic objectForKey:@"type"] integerValue] == 1) {
            self.viewHeight = 220;
        }else{
            self.viewHeight = 195;
        }
    }
    return YES;
}

@end
