//
//  TTTranslucentView.m
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTranslucentView.h"

@interface TTTranslucentView()

@property (nonatomic, strong) UIToolbar *tooldbar;

@end

@implementation TTTranslucentView

- (id)init
{
    self = [super init];
    if (self) {
        [self ttCommonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self ttCommonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self ttCommonInit];
    }
    return self;
}

- (void)ttCommonInit
{
    self.tooldbar = [[UIToolbar alloc] initWithFrame:self.bounds];
//    self.tooldbar.barStyle = UIBarStyleBlack;
    [self.layer insertSublayer:self.tooldbar.layer atIndex:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.tooldbar.frame = self.bounds;
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        self.tooldbar.tintColor = _tintColor;
    }
}

@end