//
//  TTTrain.h
//  Ttime
//
//  Created by Andrew Barba on 10/15/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAObject.h"

@interface TTTrain : TTMBTAObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *outboundStation;

@property (nonatomic, strong) NSString *inboundStation;

@property (nonatomic, strong) NSArray *routeIDs;

@property (nonatomic, strong) NSArray *stops;

- (CLLocationDistance)distanceToClosestStop:(CLLocation *)location;

- (NSArray *)stopsSortedForLocation:(CLLocation *)location;

- (TTStop *)closestStopToLocation:(CLLocation *)location;

@end
