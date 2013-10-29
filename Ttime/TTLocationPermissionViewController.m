//
//  TTLocationPermissionViewController.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTLocationPermissionViewController.h"

@interface TTLocationPermissionViewController ()

@end

@implementation TTLocationPermissionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[TTTracker sharedTracker] trackScreenWithName:@"Location Permission"];
}

- (IBAction)_handleGetLocationPermission:(id)sender
{
    [[TTLocationManager sharedManager] startUpdatingLocation];
    [[TTTracker sharedTracker] trackEvent:@"getting_location_permission" withName:@"Asked for location"];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
