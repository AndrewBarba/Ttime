//
//  TTMBTAService.m
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAService.h"

@implementation TTMBTAService

#pragma mark - Closest Stop

- (void)fetchClostestStopsWithLatitude:(float)lat
                             longitude:(float)lon
                          onCompletion:(TTRequestArrayBlock)complete
{
    NSDictionary *params = @{@"lat" : @(lat), @"lon" : @(lon)};
    [TTMBTAClient asyncMBTARequest:@"/stopsbylocation"
                              data:params
                        completion:^(NSDictionary *json, NSError *error){
                            if (json && !error) {
                                NSMutableArray *stops = [NSMutableArray array];
                                for (NSDictionary *stopDict in json[@"stop"]) {
                                    TTStop *stop = [TTStop mbtaObjectFromDictionary:stopDict];
                                    [stops addObject:stop];
                                }
                                if (complete) {
                                    complete(stops, nil);
                                }
                            } else {
                                if (complete) {
                                    complete(nil, error);
                                }
                            }
                        }];
}

#pragma mark - Initialization

+ (instancetype)sharedService
{
    static id service = nil;
    TT_DISPATCH_ONCE(^{
        service = [[self alloc] init];
    });
    return service;
}

@end
