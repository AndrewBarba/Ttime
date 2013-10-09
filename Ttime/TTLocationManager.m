//
//  TTLocationManager.m
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTLocationManager.h"

@interface TTLocationManager() {
    TTLocationBlock _locationBlock;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation TTLocationManager

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

#pragma mark - Get Location

- (void)getCurrentLocation:(TTLocationBlock)block
{
    if (!block) return;
    
    TTLocationStatus locationStatus = [TTLocationManager locationStatus];
    
    if (locationStatus != TTLocationStatusOkay) {
        return block(nil, locationStatus);
    }
    
    _locationBlock = [block copy];
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    
    if (_locationBlock) {
        _locationBlock(location, [TTLocationManager locationStatus]);
        _locationBlock = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    
    if (_locationBlock) {
        _locationBlock(nil, [TTLocationManager locationStatus]);
        _locationBlock = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Location status changed: %i", status);
}

#pragma mark - Initialization

- (void)_setupLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 50; // only update location when they move > 50 meters
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
