//
//  TTCollectionLineCell.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTCollectionLineCell.h"
#import "TTCollectionLineCell.h" // this is out collection view cell class

@implementation TTCollectionLineCell


-(void)updateCell:(TTStop *)stop forInbound:(BOOL)inbound andColor:(UIColor *)color
{
    self.stopLabel.textColor = color;
    self.stopLabel.text = [NSString stringWithFormat:@"%@", stop.name];
    self.destinationLabel.textColor = color;
    self.destinationLabel.text = [NSString stringWithFormat:@"%@",
                                  inbound ? stop.train.inboundStation : stop.train.outboundStation];
    self.distanceLabel.textColor = color;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@",
                               [self distanceToStop:stop]];
    
    
    
    self.timeView.tintColor = color;
    
    if (inbound) {
        [self.timeView setDepartureDate:[stop.ttime.inboundDepartureDates firstObject]];
    } else {
        [self.timeView setDepartureDate:[stop.ttime.outboundDepartureDates firstObject]];
    }

    
}

-(NSString *)distanceToStop:(TTStop *)stop
{
#warning I dont like this logic. Lets move this to a class thats more suited to returning this kind of info. \
It's fine that this method returns a string but there should be a method somewhere else that converts meters to miles
    CLLocationDistance distance = [stop distanceFromLocation:
                                   [[TTLocationManager sharedManager] currentLocation]];
    distance = distance * 0.000621371;
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:distance]];
    
}



@end
