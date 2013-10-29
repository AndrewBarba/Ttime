//
//  UIView+TT.m
//  Ttime
//
//  Created by Andrew Barba on 10/28/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "UIView+TT.h"

@implementation UIView (TT)

- (void)enableParallax:(CGFloat)intensity
{
    if (TL_IS_IOS7()) {
        UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        interpolationHorizontal.minimumRelativeValue = @(intensity);
        interpolationHorizontal.maximumRelativeValue = @(intensity*-1.0);
        
        UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        interpolationVertical.minimumRelativeValue = @(intensity);
        interpolationVertical.maximumRelativeValue = @(intensity*-1.0);
        
        [self addMotionEffect:interpolationHorizontal];
        [self addMotionEffect:interpolationVertical];
    }
}

@end
