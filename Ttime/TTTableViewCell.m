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


@end
