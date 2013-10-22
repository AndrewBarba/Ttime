//
//  TTCircleView.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTCircleView.h"

@interface TTCircleView() {
    BOOL _isAnimating;
}

@end

@implementation TTCircleView

- (void)drawRect:(CGRect)rect
{
    CGFloat width  = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat side   = MIN(width,height);
    
    CGFloat thickness = 8.0;
    CGFloat gap = thickness / 4.0;
    CGFloat radius = (side / 2.0) - (thickness / 2.0) - gap;
    CGFloat x = width / 2.0;
    CGFloat y = height / 2.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the width of the line
    CGContextSetLineWidth(context, thickness);
    
    // Green
    CGContextBeginPath(context);
    CGContextAddArc(context, x+gap, y-gap, radius, 2.0*M_PI, 1.5*M_PI, YES);
    CGContextSetRGBStrokeColor(context, 0.0/255.0, 165.0/255.0, 81.0/255.0, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Blue
    CGContextBeginPath(context);
    CGContextAddArc(context, x+gap, y+gap, radius, 0.5*M_PI, 0.0*M_PI, YES);
    CGContextSetRGBStrokeColor(context, 46.0/255.0, 49.0/255.0, 145.0/255.0, 1.0);
    CGContextDrawPath(context, kCGPathStroke);

    // Orange
    CGContextBeginPath(context);
    CGContextAddArc(context, x-gap, y+gap, radius, 1.0*M_PI, 0.5*M_PI, YES);
    CGContextSetRGBStrokeColor(context, 240.0/255.0, 90.0/255.0, 40.0/255.0, 1.0);
    CGContextDrawPath(context, kCGPathStroke);

    // Red
    CGContextBeginPath(context);
    CGContextAddArc(context, x-gap, y-gap, radius, 1.5*M_PI, 1.0*M_PI, YES);
    CGContextSetRGBStrokeColor(context, 236.0/255.0, 28.0/255.0, 36.0/255.0, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)_animate
{
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    
    //Do a series of 5 quarter turns for a total of a 1.25 turns
    //(2PI is a full turn, so pi/2 is a quarter turn)
    [rotate setToValue: [NSNumber numberWithFloat: -M_PI / 2]];
    rotate.repeatCount = 11;
    
    rotate.duration = 5.5;
    rotate.cumulative = YES;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer addAnimation:rotate forKey: @"rotateAnimation"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_isAnimating) {
        [self _animate];
    }
}

#pragma mark - Initialization

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

@end
