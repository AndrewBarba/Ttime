//
//  TTLocationManager.m
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTLocationManager.h"

#define TT_DISTANCE_THRESHOLD 25.0f

@interface TTLocationManager()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation TTLocationManager

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Location Status

+ (TTLocationStatus)locationStatus
{
    if (![CLLocationManager locationServicesEnabled]) {
        return TTLocationStatusDisabled;
    }
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined: return TTLocationStatusNotDetermined;
        case kCLAuthorizationStatusRestricted:    return TTLocationStatusRestricted;
        case kCLAuthorizationStatusDenied:        return TTLocationStatusDenied;
        case kCLAuthorizationStatusAuthorized:    return TTLocationStatusOkay;
    }
}

#pragma mark - Location Delegate

- (void)setCurrentLocation:(CLLocation *)currentLocation
{
    BOOL equal = [_currentLocation isEqual:currentLocation];
    CLLocationDistance distance = [_currentLocation distanceFromLocation:currentLocation];
    if (!_currentLocation || (!equal && distance > TT_DISTANCE_THRESHOLD)) {
        _currentLocation = currentLocation;
        [[NSNotificationCenter defaultCenter] postNotificationName:TTCurrentLocationChangedNotificationKey
                                                            object:_currentLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self setCurrentLocation:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self setCurrentLocation:nil];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TTLocationStatusChangedNotificationKey
                                                        object:@([TTLocationManager locationStatus])];
}

#pragma mark - Initialization

- (void)_setupLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = TT_DISTANCE_THRESHOLD; // only update location when they move > 50 meters
}

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        [self _setupLocationManager];
    }
    return self;
}

+ (instancetype)sharedManager
{
    static id manager = nil;
    TT_DISPATCH_ONCE(^{
        manager = [[self alloc] _initPrivate];
    });
    return manager;
}

@end
