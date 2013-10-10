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
#import "TTTimeService.h"

@interface TTViewController ()

@property (nonatomic, weak) IBOutlet TTTranslucentView *translucentView;
@property (nonatomic, weak) IBOutlet UILabel *greenLabel;
@property (nonatomic, weak) IBOutlet UILabel *redLabel;
@property (nonatomic, weak) IBOutlet UILabel *blueLabel;
@property (nonatomic, weak) IBOutlet UILabel *orangeLabel;

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_handleTimesUpdatedNotification:)
                                                 name:TTUpdatedTimeNotificationKey
                                               object:nil];
}

- (void)loop
{
    [self _updateLabels];
    
    TTDispatchAfter(0.5, ^{
        [self loop];
    });
}

- (void)_handleTimesUpdatedNotification:(NSNotification *)notification
{
    [self _updateLabels];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loop];
    
    [self _getLocation];
}

- (void)_getLocation
{
    [[TTLocationManager sharedManager] getCurrentLocation:^(CLLocation *location, TTLocationStatus status){
        
        [[TTTimeService sharedService] updateTTimesForLocation:location onCompletion:^{
            
            TTDispatchAfter(5.0, ^{
                [self _getLocation];
            });
            
            [self _updateLabels];
        }];
        
    }];
}

- (void)_updateLabels
{
    TTTime *red = [[TTTimeService sharedService] redLineTTime];
    self.redLabel.text = [NSString stringWithFormat:@"%@ >> %@",
                          [self prettyPrintTime:red.secondsToInboundDeparture],
                          [self prettyPrintTime:red.secondsToOutboundDeparture]];
    
    TTTime *green = [[TTTimeService sharedService] greenLineTTime];
    self.greenLabel.text = [NSString stringWithFormat:@"%@ >> %@",
                          [self prettyPrintTime:green.secondsToInboundDeparture],
                          [self prettyPrintTime:green.secondsToOutboundDeparture]];
    
    TTTime *blue = [[TTTimeService sharedService] blueLineTTime];
    self.blueLabel.text = [NSString stringWithFormat:@"%@ >> %@",
                          [self prettyPrintTime:blue.secondsToInboundDeparture],
                          [self prettyPrintTime:blue.secondsToOutboundDeparture]];
    
    TTTime *orange = [[TTTimeService sharedService] orangeLineTTime];
    self.orangeLabel.text = [NSString stringWithFormat:@"%@ >> %@",
                          [self prettyPrintTime:orange.secondsToInboundDeparture],
                          [self prettyPrintTime:orange.secondsToOutboundDeparture]];
}

- (NSString *)prettyPrintTime:(NSTimeInterval)seconds
{
    if (seconds < 60) {
        if (seconds > 0) {
            return [NSString stringWithFormat:@"%i seconds", (int)seconds];
        } else {
            return [NSString stringWithFormat:@"Loading..."];
        }
    }
    
    int min = (int)(seconds / 60);
    NSString *time = [NSString stringWithFormat:@"%i minute", min];
    if (min > 1) {
        time = [time stringByAppendingString:@"s"];
    }
    
    return time;
}

@end
