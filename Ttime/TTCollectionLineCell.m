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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)updateCell:(TTStop *)stop forInbound:(BOOL)inbound andColor:(UIColor *)color
{
    self.stopLabel.textColor = color;
    self.stopLabel.text = [NSString stringWithFormat:@"%@", stop.name];
    [self.timeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.destinationLabel.textColor = color;
    self.destinationLabel.text = [NSString stringWithFormat:@"%@",
                                  self.inbound ? stop.train.inboundStation : stop.train.outboundStation];
    self.distanceLabel.textColor = color;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@",
                               [self distanceToStop:stop]];
    
    
    
    if (stop.ttime) {
        self.ttime = stop.ttime;
        [self.timeButton setTitle:[NSString stringWithFormat:@"%@", [self timeTillDeparture:stop.ttime atIndex:0]]
                         forState:UIControlStateNormal];
    } else {
        [self.timeButton setTitle:@"..." forState:UIControlStateNormal];
    }

    
}



- (NSString *)timeTillDeparture:(TTTime *)ttime atIndex:(NSInteger *)index
{
#warning This will not be needed once you start using my custom TTCircleTimeView
    NSTimeInterval seconds;
    
    if (self.inbound)
    {
        seconds = [ttime secondsToInboundDeparture:0];
    } else {
        seconds = [ttime secondsToOutboundDeparture:0];
    }
    
    if (seconds < 1) return @"...";
    
    if (seconds < 60) {
        return [NSString stringWithFormat:@"%i\nsec", (int)seconds];
    }
    
    NSInteger min = (int)(seconds / 60);
    NSString *string = [NSString stringWithFormat:@"%li\nmin", (long)min];
    return string;
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
