//
//  TTTime.m
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTime.h"

static NSString *const _TTRedLine    = @"Red Line";
static NSString *const _TTOrangeLine = @"Orange Line";
static NSString *const _TTBlueLine   = @"Blue Line";
static NSString *const _TTGreenLine  = @"Green Line";

@implementation TTTime

- (double)distanceInMiles
{
    double distanceInMeters = [self.stop distanceFromLocation:self.location];
    return distanceInMeters * 0.000621371;
}

- (NSTimeInterval)secondsToInboundDeparture:(NSUInteger)index
{
    if (self.inboundDepartureDates.count > index) {
        NSDate *date = self.inboundDepartureDates[index];
        return [date timeIntervalSinceDate:[NSDate date]];
    } else {
        return -1;
    }
}

- (NSTimeInterval)secondsToOutboundDeparture:(NSUInteger)index
{
    if (self.outboundDepartureDates.count > index) {
        NSDate *date = self.outboundDepartureDates[index];
        return [date timeIntervalSinceDate:[NSDate date]];
    } else {
        return -1;
    }
}

#pragma mark - Initialization

+ (NSString *)uniqueIdentifier
{
    return @"route_id";
}

+ (instancetype)mbtaObjectFromDictionary:(NSDictionary *)dict
{
    TTTime *ttime = [super mbtaObjectFromDictionary:dict];
    
    if (ttime) {
        
        if ([dict containsNonEmptyJSONValueForKey:@"route_name"]) {
            NSString *routeName = dict[@"route_name"];
            ttime.line = [self lineForRouteName:routeName];
        }
        
        if ([dict containsNonEmptyJSONValueForKey:@"direction"]) {
            NSMutableArray *outboundDates = [NSMutableArray array];
            NSMutableArray *inboundDates = [NSMutableArray array];
            for (NSDictionary *direction in dict[@"direction"]) {
                TTDirection lineDirection = [direction[@"direction_id"] integerValue];
                for (NSDictionary *trip in direction[@"trip"]) {
                    NSTimeInterval departTime = [trip[@"sch_dep_dt"] doubleValue];
                    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:departTime];
                    
                    switch (lineDirection) {
                        case TTDirectionOutbound:
                            [outboundDates addObject:departDate];
                            break;
                            
                        case TTDirectionInbound:
                            [inboundDates addObject:departDate];
                            break;
                            
                        case TTDirectionUnknown:
                            // something went wrong...
                            break;
                    }
                }
            }
            ttime.outboundDepartureDates = outboundDates;
            ttime.inboundDepartureDates = inboundDates;
        }
    }
    
    return ttime;
}

+ (TTLine)lineForRouteName:(NSString *)routeName
{
    if ([routeName isEqualToString:_TTRedLine]) {
        return TTLineRed;
    }
    
    if ([routeName isEqualToString:_TTBlueLine]) {
        return TTLineBlue;
    }
    
    if ([routeName isEqualToString:_TTGreenLine]) {
        return TTLineGreen;
    }
    
    if ([routeName isEqualToString:_TTOrangeLine]) {
        return TTLineOrange;
    }
    
    return TTLineUnknown;
}

@end
