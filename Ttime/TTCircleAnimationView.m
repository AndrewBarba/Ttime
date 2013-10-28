//
//  TTCircleAnimationView.m
//  Ttime
//
//  Created by Andrew Barba on 10/28/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTCircleAnimationView.h"

@interface TTCircleAnimationView() {
    BOOL _isAnimating;
}

@end

@implementation TTCircleAnimationView

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

@end
