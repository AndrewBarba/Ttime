//
//  TTLocationManager.h
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, TTLocationStatus) {
    
    TTLocationStatusOkay = 0, // location ready
    
    TTLocationStatusNotDetermined = -1, // have not asked for location yet
    
    TTLocationStatusRestricted = 1, // device is restricted (maybe parental controls?)
    
    TTLocationStatusDenied = 2, // user denied us location permission
    
    TTLocationStatusDisabled = 3, // device location is turned off in settings
};

typedef void (^TTLocationBlock) (CLLocation *location, TTLocationStatus locationStatus);

@interface TTLocationManager : NSObject <CLLocationManagerDelegate>

/**
 * Asynchronously attempts to get the users current location
 */
- (void)getCurrentLocation:(TTLocationBlock)block;

+ (instancetype)sharedManager;

@end
