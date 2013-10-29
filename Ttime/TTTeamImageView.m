//
//  TTTeamImageView.m
//  Ttime
//
//  Created by Andrew Barba on 10/28/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTeamImageView.h"

@implementation TTTeamImageView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.width / 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
}

@end
