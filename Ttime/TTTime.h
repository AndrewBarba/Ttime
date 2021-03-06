//
//  TTTime.h
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAObject.h"

@interface TTTime : TTMBTAObject

@property (nonatomic, strong) TTStop *stop;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) NSArray *inboundDepartureDates;

@property (nonatomic, strong) NSArray *outboundDepartureDates;

@property (nonatomic) TTLine line;

- (double)distanceInMiles;

- (NSTimeInterval)secondsToInboundDeparture:(NSUInteger)index; // train index. 0 is closest train

- (NSTimeInterval)secondsToOutboundDeparture:(NSUInteger)index;

@end
