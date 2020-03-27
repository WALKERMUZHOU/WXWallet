//
//  LWCurrentExchangeTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/27.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWCurrentExchangeTool.h"
#import "LWHomeListCoordinator.h"

@interface LWCurrentExchangeTool (){
    dispatch_source_t _timer;
}

@end

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
        [self startRecycleRequestCurrency];
    } WithFailBlock:^(id  _Nonnull data) {
        [self getCurrentExchange];
    }];
}

- (void)startRecycleRequestCurrency{
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
                
    dispatch_source_set_timer(_timer, 30 * NSEC_PER_SEC, 30 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [LWHomeListCoordinator getTokenPriceWithSuccessBlock:^(id  _Nonnull data) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCuurentCurrencyChange_nsnotification object:nil];
        } WithFailBlock:^(id  _Nonnull data) {

        }];

    });
    dispatch_resume(_timer);
}

@end
