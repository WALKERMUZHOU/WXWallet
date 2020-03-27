//
//  LWCurrentExchangeTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWCurrentExchangeTool.h"
#import "LWHomeListCoordinator.h"

@implementation LWCurrentExchangeTool

static LWCurrentExchangeTool *instance = nil;
+ (LWCurrentExchangeTool *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWCurrentExchangeTool alloc]init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
//        [self initData];
    }
    return self;
}

- (void)getCurrentExchange{
        [LWHomeListCoordinator getTokenPriceWithSuccessBlock:^(id  _Nonnull data) {
            
        } WithFailBlock:^(id  _Nonnull data) {
            [self getCurrentExchange];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(timer, ^{
                [LWHomeListCoordinator getTokenPriceWithSuccessBlock:^(id  _Nonnull data) {
    
                } WithFailBlock:^(id  _Nonnull data) {
                    [self getCurrentExchange];
                }];
            });
            dispatch_resume(timer);
        });
}

@end
