//
//  TTRootViewController.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTRootViewController.h"

@interface TTRootViewController ()

@end

@implementation TTRootViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    TT_DISPATCH_ONCE(^{
        TTDispatchAfter(0.5, ^{
            [self _performOpeningSegue];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_handleLocationStatusChanged:)
                                                         name:TTLocationStatusChangedNotificationKey
                                                       object:nil];
        });
    });
}

#pragma mark - Segue

- (void)_performOpeningSegue
{
    if ([TTLocationManager locationStatus] == TTLocationStatusOkay) {
        [self _performMainSegue];
    } else {
        [self _performLocationPermissionSegue];
    }
}

- (void)_performMainSegue
{
    [self performSegueWithIdentifier:@"Main Segue" sender:self];
}

- (void)_performLocationPermissionSegue
{
    [self performSegueWithIdentifier:@"Location Permission Segue" sender:self];
}

#pragma mark - Notification

- (void)_handleLocationStatusChanged:(NSNotification *)notification
{
    if ([TTLocationManager locationStatus] == TTLocationStatusOkay) {
        [self _performMainSegue];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Location", nil)
                                    message:NSLocalizedString(@"It looks like we do not have location permissions. In order to use TTIME we need to know where you are so we can track the closest T stations. Please go to Settings -> Privacy -> Location Services and then make sure TTIME is enabled.", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                          otherButtonTitles:nil] show];
    }
}

@end
