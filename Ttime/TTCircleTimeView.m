//
//  TTCircleTimeView.m
//  Ttime
//
//  Created by Andrew Barba on 10/16/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTCircleTimeView.h"

#define TT_MAX_INTERVAL (20.0 * 60) // 20 min ago

#define TT_TIMER_INT (1.0f / 3.0f)

@interface TTCircleTimeView() {
    NSTimer *_updateTimer;
}

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) CAShapeLayer *circleAnimationLayer;

@property (nonatomic, strong) UILabel *label;

@end

@implementation TTCircleTimeView

- (void)updateLayout:(NSTimer *)timer
{
    [self updateLabel];
    self.circleAnimationLayer.strokeEnd = [self percentComplete];
}

- (void)setDepartureDate:(NSDate *)departureDate
{
    if (![_departureDate isEqualToDate:departureDate] && departureDate) {
        _departureDate = departureDate;
    }
}

#pragma mark - State Helpers

- (void)setTintColor:(UIColor *)tintColor
{
    if ([_tintColor hash] != [tintColor hash]) {
        _tintColor = tintColor;
        _circleLayer.strokeColor = tintColor.CGColor;
        _circleAnimationLayer.strokeColor = tintColor.CGColor;
    }
}

- (CGFloat)percentComplete
{
    if (!_departureDate) {
        return 0.0f;
    }
    
    NSTimeInterval doneInterval = [_departureDate timeIntervalSince1970];
    NSTimeInterval startInterval = doneInterval - TT_MAX_INTERVAL;
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    
    if (currentInterval >= doneInterval) {
        return 1.0f;
    }
    
    if (currentInterval <= startInterval) {
        return 0.0f;
    }
    
    CGFloat done = (currentInterval - startInterval + 1) / (doneInterval - startInterval);
    return done;
}

- (NSTimeInterval)timeToCompletion
{
    NSTimeInterval doneInterval = [_departureDate timeIntervalSince1970];
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    return doneInterval - currentInterval;
}

#pragma mark - Layout Circle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_updateTimer) {
        _updateTimer = [NSTimer timerWithTimeInterval:TT_TIMER_INT
                                               target:self
                                             selector:@selector(updateLayout:)
                                             userInfo:nil
                                              repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_updateTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    _circleLayer = [self circleForView:self];
    _circleLayer.lineWidth = 4.0;
    _circleLayer.opacity = 0.3;
    _circleLayer.strokeEnd = 1.0f;
    [self.layer addSublayer:_circleLayer];
    
    _circleAnimationLayer = [self circleForView:self];
    _circleAnimationLayer.lineWidth = 4.0;
    _circleAnimationLayer.opacity = 1.0;
    _circleAnimationLayer.strokeEnd = 0.0;
    [self.layer addSublayer:_circleAnimationLayer];
}

- (void)updateLabel
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
        
//        [_label enableParallax:10.0];
        
        [self addSubview:_label];
    }
    _label.attributedText = [self attributedTextForLabel];
}

- (NSAttributedString *)attributedTextForLabel
{
    NSTimeInterval seconds = [self timeToCompletion];
    BOOL useSeconds = seconds <= 60;
    NSInteger t = useSeconds ? (int)seconds : (int)(seconds / 60);
    t = MAX(0,t);
    
    NSString *labelText = useSeconds ? @"second" : @"minute";
    if (t != 1) labelText = [labelText stringByAppendingString:@"s"];
    
    NSString *timeText = [NSString stringWithFormat:@"%@",@(t).stringValue];
    
    CGFloat radius = MIN(self.bounds.size.width / 2.0f,
                         self.bounds.size.height / 2.0f);
    
    NSDictionary *timeAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:radius],
                               NSForegroundColorAttributeName : self.tintColor};
    
    NSDictionary *labelAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:(radius * 0.30)],
                                NSForegroundColorAttributeName : self.tintColor};
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:timeText attributes:timeAttr];
    NSAttributedString *sep = [[NSAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithString:labelText attributes:labelAttr];
    
    [text appendAttributedString:sep];
    [text appendAttributedString:text2];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineHeightMultiple = 0.8;
    [text addAttribute:NSParagraphStyleAttributeName
                 value:style
                 range:NSMakeRange(0, text.length)];
    
    return text;
}

- (CAShapeLayer *)circleForView:(UIView *)view
{
    // Set up the shape of the circle
    CGFloat radius = MIN(view.bounds.size.width / 2.0f,
                         view.bounds.size.height / 2.0f);
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(view.bounds)-radius,
                                  CGRectGetMidY(view.bounds)-radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = self.tintColor ? self.tintColor.CGColor : [UIColor blackColor].CGColor;
    circle.lineWidth = 8;
    
    return circle;
}

#pragma mark - Initialization

- (void)commonInit
{
    _tintColor = [UIColor blueColor];
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

#pragma mark - Save for later

- (void)animate
{
    return;
    if (self.superview && self.circleAnimationLayer && _departureDate) {
        [self.circleAnimationLayer removeAllAnimations];
        
        // Configure animation
        CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawAnimation.delegate = self;
        drawAnimation.duration            = [self timeToCompletion]; // "animate over 10 seconds or so.."
        drawAnimation.repeatCount         = 1.0;  // Animate only once..
        drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
        
        // Animate from no part of the stroke being drawn to the entire stroke being drawn
        drawAnimation.fromValue = [NSNumber numberWithFloat:[self percentComplete]];
        drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
        
        // Experiment with timing to get the appearence to look the way you want
        drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [_circleAnimationLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.circleAnimationLayer.strokeEnd = [[(CABasicAnimation *)anim fromValue] floatValue];
    } else {
        [self animate];
    }
}

@end
