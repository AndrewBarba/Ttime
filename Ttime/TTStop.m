//
//  TTStop.m
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTStop.h"

@implementation TTStop

#pragma mark - Stop

+ (instancetype)mbtaObjectFromDictionary:(NSDictionary *)dict
{
    TTStop *stop = [super mbtaObjectFromDictionary:dict];
    
    if (stop) {
        
        if ([dict containsNonEmptyJSONValueForKey:@"parent_station_name"]) {
            stop.name = dict[@"parent_station_name"];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"stop_lat"] && [dict containsNonEmptyJSONValueForKey:@"stop_lon"]) {
            CLLocationDistance lat = [dict[@"stop_lat"] doubleValue];
            CLLocationDistance lon = [dict[@"stop_lon"] doubleValue];
            stop.location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        }
    }
    
    return stop;
}

- (CLLocationDistance)distanceFromLocation:(CLLocation *)location
{
    return [self.location distanceFromLocation:location];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ <%f,%f>",
            self.name,
            self.location.coordinate.latitude,
            self.location.coordinate.longitude];
}

@end
