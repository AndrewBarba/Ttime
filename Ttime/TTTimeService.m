//
//  TTTimeService.m
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTimeService.h"
#import "TTMBTAClient.h"

@implementation TTTimeService

- (void)fetchTTimeForStop:(TTStop *)stop onCompletion:(TTTimeBlock)complete
{
    NSDictionary *params = @{ @"stop" : stop.id };
    [TTMBTAClient asyncMBTARequest:@"/schedulebystop" data:params completion:^(NSDictionary *schedule, NSError *error){
        if (schedule && !error) {
            for (NSDictionary *mode in schedule[@"mode"]) {
                for (NSDictionary *route in mode[@"route"]) {
                    if ([stop.train.routeIDs containsObject:route[@"route_id"]]) {
                        TTTime *time = [TTTime mbtaObjectFromDictionary:route];
                        time.stop = stop;
                        if (complete) {
                            complete(time, nil);
                        }
                        return;
                    }
                }
            }
            if (complete) {
                NSError *e = [NSError errorWithDomain:@"Not found" code:NSNotFound userInfo:@{}];
                complete(nil, e);
            }
        } else {
            if (complete) {
                complete(nil, error);
            }
        }
    }];
}

#pragma mark - Initialization

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        // setup
    }
    return self;
}

+ (instancetype)sharedService
{
    static id manager = nil;
    TT_DISPATCH_ONCE(^{
        manager = [[self alloc] _initPrivate];
    });
    return manager;
}

@end
