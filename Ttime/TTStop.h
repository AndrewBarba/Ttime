//
//  TTStop.h
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAObject.h"

@class TTTrain;

@interface TTStop : TTMBTAObject

@property (nonatomic, strong) TTTrain *train;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) CLLocation *location;

- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;

@end
