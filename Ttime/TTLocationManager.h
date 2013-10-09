//
//  TTLocationManager.h
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, TTLocationStatus) {
    TTLocationStatusNotDetermined = 0,
    TTLocationStatusRestricted,
    TTLocationStatusDenied,
    TTLocationStatusDisabled,
    TTLocationStatusOkay
};

typedef void (^TTLocationBlock) (CLLocation *location, TTLocationStatus locationStatus);

@interface TTLocationManager : NSObject <CLLocationManagerDelegate>

/**
 * Asynchronously attempts to get the users current location
 */
- (void)getCurrentLocation:(TTLocationBlock)block;

+ (instancetype)sharedManager;

@end
