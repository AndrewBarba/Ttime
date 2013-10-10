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

- (NSTimeInterval)secondsToInboundDeparture
{
    return [self.inboundDepartureDate timeIntervalSinceDate:[NSDate date]];
}

- (NSTimeInterval)secondsToOutboundDeparture
{
    return [self.outboundDepartureDate timeIntervalSinceDate:[NSDate date]];
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
            NSArray *directions = dict[@"direction"];
            for (NSDictionary *direction in directions) {
                TTDirection lineDirection = [direction[@"direction_id"] integerValue];
                NSDictionary *trip = [direction[@"trip"] firstObject];
                NSTimeInterval departTime = [trip[@"sch_arr_dt"] doubleValue];
                NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:departTime];
                
                switch (lineDirection) {
                    case TTDirectionOutbound:
                        ttime.outboundDepartureDate = departDate;
                        break;
                        
                    case TTDirectionInbound:
                        ttime.inboundDepartureDate = departDate;
                        break;
                    
                    case TTDirectionUnknown:
                        // something went wrong...
                        break;
                }
            }
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
