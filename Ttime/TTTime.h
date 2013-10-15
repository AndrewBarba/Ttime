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

@property (nonatomic, strong) NSDate *inboundDepartureDate;

@property (nonatomic, strong) NSDate *outboundDepartureDate;

@property (nonatomic) TTLine line;

- (double)distanceInMiles;

- (NSTimeInterval)secondsToInboundDeparture;

- (NSTimeInterval)secondsToOutboundDeparture;

@end
