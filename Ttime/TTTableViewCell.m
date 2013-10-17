//
//  TTTableViewCell.m
//  Ttime
//
//  Created by Zacharia Bachiri on 10/16/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTableViewCell.h"

@implementation TTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _currentIndex = 0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)nextTrainTime:(id)sender {
    
    _currentIndex = (_currentIndex + 1) % [_ttime.inboundDepartureDates count];
}



/*
- (void)updateCell:(TTTime *)ttime forDirection:(BOOL)inbound
{
    if (ttime) {
        _stationLabel.text = [NSString stringWithFormat:@"%@", ttime.stop.name];
        [_timeButton setTitle:[NSString stringWithFormat:@"%@", [self timeTillDeparture:ttime forDirection:inbound]]
                         forState:UIControlStateNormal];
        _destinationLabel.text = [NSString stringWithFormat:@"%@",
                                      inbound ? ttime.stop.train.inboundStation : ttime.stop.train.outboundStation];
    } else {
        [_timeButton setTitle:@"..." forState:UIControlStateNormal];
        _stationLabel.text = @"loading...";
    }
}

- (NSString *)timeTillDeparture:(TTTime *)ttime forDirection:(BOOL)inbound
{
    NSTimeInterval seconds = inbound ? [ttime secondsToInboundDeparture:0] : [ttime secondsToOutboundDeparture:0];
    if (seconds <= 0) return @"Loading...";
    
    if (seconds < 60) {
        return [NSString stringWithFormat:@"%i sec", (int)seconds];
    }
    
    NSInteger min = (int)(seconds / 60);
    NSString *string = [NSString stringWithFormat:@"%li min", (long)min];
    if (min > 1) string = [string stringByAppendingString:@"s"];
    return string;
}
*/

@end
