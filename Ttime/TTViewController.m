//
//  TTViewController.m
//  Ttime
//
//  Created by Andrew Barba on 8/5/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTViewController.h"
#import "TTLocationManager.h"

@interface TTViewController ()

@end

@implementation TTViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[TTLocationManager sharedManager] getCurrentLocation:^(CLLocation *location, TTLocationStatus status){
        NSLog(@"%@ : %lu", location, status);
    }];
}

@end
