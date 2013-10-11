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
@property BOOL inbound;
@property (weak, nonatomic) IBOutlet UIButton *inboundOutboundButton;

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _inbound = YES;
    [_inboundOutboundButton setTitle:@"Inbound" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_handleTimesUpdatedNotification:)
                                                 name:TTUpdatedTimeNotificationKey
                                               object:nil];
}


- (IBAction)changeDirection:(id)sender {
    if (_inbound) {
        [_inboundOutboundButton setTitle:@"Outbound" forState:UIControlStateNormal];
    } else {
        [_inboundOutboundButton setTitle:@"Inbound" forState:UIControlStateNormal];
    }
    _inbound = !_inbound;
    [self _updateLabels];
    

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
    TTTime *green = [[TTTimeService sharedService] greenLineTTime];
    TTTime *blue = [[TTTimeService sharedService] blueLineTTime];
    TTTime *orange = [[TTTimeService sharedService] orangeLineTTime];
    
    if (_inbound)
    {
        self.redLabel.text = [NSString stringWithFormat:@"%@[final stop]: %@",
                          red.stop.name ,[self prettyPrintTime:red.secondsToInboundDeparture]];
        self.greenLabel.text = [NSString stringWithFormat:@"%@[final stop]: %@",
                          green.stop.name, [self prettyPrintTime:green.secondsToInboundDeparture]];
        self.blueLabel.text = [NSString stringWithFormat:@"%@[final stop]: %@",
                          blue.stop.name, [self prettyPrintTime:blue.secondsToInboundDeparture]];
        self.orangeLabel.text = [NSString stringWithFormat:@"%@[final stop]: %@",
                          orange.stop.name, [self prettyPrintTime:orange.secondsToInboundDeparture]];
    } else {
        
        self.redLabel.text = [NSString stringWithFormat:@"%@[final stop]: %@",
                              red.stop.name, [self prettyPrintTime:red.secondsToOutboundDeparture]];
        self.greenLabel.text = [NSString stringWithFormat:@"%@[final stop]: %@",
                                green.stop.name, [self prettyPrintTime:green.secondsToOutboundDeparture]];
        self.blueLabel.text = [NSString stringWithFormat:@"%@[final stop]: %@",
                               blue.stop.name, [self prettyPrintTime:blue.secondsToOutboundDeparture]];
        self.orangeLabel.text = [NSString stringWithFormat:@"%@[final stop]: %@",
                                 orange.stop.name, [self prettyPrintTime:orange.secondsToOutboundDeparture]];
    }
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
