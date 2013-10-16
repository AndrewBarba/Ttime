//
//  TTLocationManager.h
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const TTCurrentLocationChangedNotificationKey = @"TTCurrentLocationChangedNotification";
static NSString *const TTLocationStatusChangedNotificationKey = @"TTLocationStatusChangedNotification";

typedef NS_ENUM(NSInteger, TTLocationStatus) {
    TTLocationStatusOkay = 0, // location ready
    TTLocationStatusNotDetermined = -1, // have not asked for location yet
    TTLocationStatusRestricted = 1, // device is restricted (maybe parental controls?)
    TTLocationStatusDenied = 2, // user denied us location permission
    TTLocationStatusDisabled = 3, // device location is turned off in settings
};

typedef void (^TTLocationBlock) (CLLocation *location, TTLocationStatus locationStatus);

@interface TTLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (TTLocationStatus)locationStatus;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

+ (instancetype)sharedManager;

@end
