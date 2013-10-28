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

- (IBAction)_handleGetLocationPermission:(id)sender
{
    [[TTLocationManager sharedManager] startUpdatingLocation];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
