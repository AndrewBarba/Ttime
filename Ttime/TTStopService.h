//
//  TTStopService.h
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTStopService : NSObject

- (TTStop *)closestRedLineStop:(CLLocation *)location;

- (TTStop *)closestBlueLineStop:(CLLocation *)location;

- (TTStop *)closestOrangeLineStop:(CLLocation *)location;

- (TTStop *)closestGreenLineStop:(CLLocation *)location;

- (TTStop *)closestStopOnLine:(TTLine)line toLocation:(CLLocation *)location;

+ (instancetype)sharedService;

@end
