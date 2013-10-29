//
//  UIColor+TT.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "UIColor+TT.h"

@implementation UIColor (TT)

// implement the rest

// Green R:0.0/255.0, G:165.0/255.0, B:81.0/255.0

// Blue R:46.0/255.0, G:49.0/255.0, B:145.0/255.0

// Orange R:240.0/255.0, G:90.0/255.0, B:40.0/255.0

// Red R:236.0/255.0, G:28.0/255.0, B:36.0/255.0



+ (instancetype)redLineColor
{
    return [UIColor colorWithRed:236.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:1.0];
}

+ (instancetype)blueLineColor
{
    return [UIColor colorWithRed:0.0/255.0 green:99.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (instancetype)greenLineColor
{
    return [UIColor colorWithRed:0.0/255.0 green:165.0/255.0 blue:81.0/255.0 alpha:1.0];
}

+ (instancetype)orangeLineColor
{
    return [UIColor colorWithRed:240.0/255.0 green:90.0/255.0 blue:40.0/255.0 alpha:1.0];
}

+ (instancetype)silverLineColor
{
    return [UIColor colorWithWhite:1.0 alpha:.8];
}





@end
