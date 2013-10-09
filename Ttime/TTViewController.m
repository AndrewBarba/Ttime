//
//  TTViewController.m
//  Ttime
//
//  Created by Andrew Barba on 8/5/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTViewController.h"
#import "TTLocationManager.h"
#import "TTStopService.h"
#import "TTTranslucentView.h"

@interface TTViewController ()

@property (nonatomic, weak) IBOutlet TTTranslucentView *translucentView;
@property (nonatomic, weak) IBOutlet UILabel *greenLabel;
@property (nonatomic, weak) IBOutlet UILabel *redLabel;
@property (nonatomic, weak) IBOutlet UILabel *blueLabel;
@property (nonatomic, weak) IBOutlet UILabel *orangeLabel;

@end

@implementation TTViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    
    [self _getLocation];
}

- (void)_getLocation
{
    [[TTLocationManager sharedManager] getCurrentLocation:^(CLLocation *location, TTLocationStatus status){
        
        [self _updateLabels:location];
        
        TTDispatchAfter(5.0, ^{
            [self _getLocation];
        });
    }];
}

- (void)_updateLabels:(CLLocation *)location
{
    TTStop *red = [[TTStopService sharedService] closestRedLineStop:location];
    self.redLabel.text = red.name;
    
    TTStop *blue = [[TTStopService sharedService] closestBlueLineStop:location];
    self.blueLabel.text = blue.name;
    
    TTStop *orange = [[TTStopService sharedService] closestOrangeLineStop:location];
    self.orangeLabel.text = orange.name;
    
    TTStop *green = [[TTStopService sharedService] closestGreenLineStop:location];
    self.greenLabel.text = green.name;
}

@end
