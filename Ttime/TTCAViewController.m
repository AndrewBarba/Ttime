//
//  TTCAViewController.m
//  Ttime
//
//  Created by Andrew Barba on 10/16/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTCAViewController.h"
#import "TTCircleTimeView.h"

@interface TTCAViewController ()

@property (nonatomic, weak) IBOutlet TTCircleTimeView *timeView;

@end

@implementation TTCAViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.timeView setTintColor:[UIColor orangeColor]];
    NSTimeInterval c = [[NSDate date] timeIntervalSince1970] + 5;
    self.timeView.doneDate = [NSDate dateWithTimeIntervalSince1970:c];
    
    TTDispatchAfter(7.0, ^{
        NSTimeInterval c = [[NSDate date] timeIntervalSince1970] + 20;
        self.timeView.doneDate = [NSDate dateWithTimeIntervalSince1970:c];
    });
}

@end
