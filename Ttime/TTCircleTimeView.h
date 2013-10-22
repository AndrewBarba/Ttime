//
//  TTCircleTimeView.h
//  Ttime
//
//  Created by Andrew Barba on 10/16/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTCircleTimeView : UIView

/**
 * The color of the circle, I will need to get you rgb values for colors
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 * Set this date and everything else is handled magically
 */
@property (nonatomic, strong) NSDate *departureDate;

@end
