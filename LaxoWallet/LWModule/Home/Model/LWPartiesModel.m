//
//  LWPartiesModel.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPartiesModel.h"

@implementation LWPartiesModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"partiesId":@"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    NSString *uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
    self.uid = uid;
    return YES;
}

@end
