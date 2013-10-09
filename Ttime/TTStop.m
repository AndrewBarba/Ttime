//
//  TTStop.m
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTStop.h"

@implementation TTStop

+ (instancetype)mbtaObjectFromDictionary:(NSDictionary *)dict
{
    TTStop *stop = [super mbtaObjectFromDictionary:dict];
    
    if (stop) {
        if ([dict containsNonEmptyJSONValueForKey:@"stop_name"]) {
            stop.name = dict[@"stop_name"];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"stop_lat"]) {
            stop.latitude = [dict[@"stop_lat"] floatValue];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"stop_lon"]) {
            stop.longitude = [dict[@"stop_lon"] floatValue];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"distance"]) {
            stop.distance = [dict[@"distance"] floatValue];
        }
    }
    
    return stop;
}

@end
