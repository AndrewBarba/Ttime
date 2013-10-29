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
    self.stopLabel.text = [stop.name uppercaseString];
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
    CLLocationDistance distance = [stop distanceFromLocation:
                                   [[TTLocationManager sharedManager] currentLocation]];
    distance = distance * 0.000621371;
    
    if (distance > 20) {
        return @"...";
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:1];
    
    NSString *num = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:distance]];
    num = [num stringByAppendingString:@" mile"];
    if (distance != 1.0) num = [num stringByAppendingString:@"s"];
    return num;
}



@end
