//
//  TTTrain.m
//  Ttime
//
//  Created by Andrew Barba on 10/15/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTrain.h"

@implementation TTTrain

+ (instancetype)mbtaObjectFromDictionary:(NSDictionary *)dict
{
    TTTrain *train = [super mbtaObjectFromDictionary:dict];
    
    if (train) {
        
        if ([dict containsNonEmptyJSONValueForKey:@"name"]) {
            train.name = dict[@"name"];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"route_ids"]) {
            train.routeIDs = dict[@"route_ids"];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"outbound_end"]) {
            train.outboundStation = dict[@"outbound_end"];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"inbound_end"]) {
            train.inboundStation = dict[@"inbound_end"];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"stops"]) {
            NSMutableArray *stops = [NSMutableArray array];
            NSDictionary *stopsDict = dict[@"stops"];
            [stopsDict enumerateKeysAndObjectsUsingBlock:^(NSDictionary *key, NSDictionary *stopDict, BOOL *end){
                TTStop *stop = [TTStop mbtaObjectFromDictionary:stopDict];
                stop.train = train;
                [stops addObject:stop];
            }];
            train.stops = stops;
        }
        
    }
    
    return train;
}

- (TTStop *)closestStopToLocation:(CLLocation *)location
{
    TTStop *closest = nil;
    CLLocationDistance closestDistance = NSIntegerMax;
    
    for (TTStop *stop in self.stops) {
        CLLocationDistance distance = [stop distanceFromLocation:location];
        if (distance < closestDistance) {
            closestDistance = distance;
            closest = stop;
        }
    }
    
    return closest;
}

- (NSArray *)stopsSortedForLocation:(CLLocation *)location
{
    return [self.stops sortedArrayUsingComparator:^NSComparisonResult(TTStop *a, TTStop *b){
        return [a distanceFromLocation:location] - [b distanceFromLocation:location];
    }];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ Train", self.name];
}

@end
