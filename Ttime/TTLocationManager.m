//
//  TTLocationManager.m
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTLocationManager.h"

@interface TTLocationManager() {
    NSMutableArray *_locationBlocks;
    BOOL _isUpdatingLocation;
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
    
    TTLocationStatus status = [TTLocationManager locationStatus];
    
    if (status != TTLocationStatusOkay && status != TTLocationStatusNotDetermined) {
        return block(nil, status);
    }
    
    [_locationBlocks addObject:[block copy]];
    
    if (!_isUpdatingLocation) {
        _isUpdatingLocation = YES;
        [self.locationManager startUpdatingLocation];
    }
}

- (void)_notifiyLocationBlocksWithLocation:(CLLocation *)location
{
    TTDispatchMain(^{
        for (TTLocationBlock block in _locationBlocks) {
            block(location, [TTLocationManager locationStatus]);
        }
        _locationBlocks = [NSMutableArray array];
    });
}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    _isUpdatingLocation = NO;
    
    CLLocation *location = [locations lastObject];
    
    [self _notifiyLocationBlocksWithLocation:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    _isUpdatingLocation = NO;
    
    [self _notifiyLocationBlocksWithLocation:nil];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
//    NSLog(@"Location status changed: %i", status);
}

#pragma mark - Initialization

- (void)_setupLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 50; // only update location when they move > 50 meters
    
    _locationBlocks = [NSMutableArray array];
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
