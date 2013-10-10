//
//  TTTimeService.h
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const TTUpdatedTimeNotificationKey = @"TTUpdatedTimeNotification";

typedef void (^TTTimeBlock) (TTTime *ttime, NSError *error);

typedef void (^TTTimesBlock) (NSArray *ttimes, NSError *error);

@interface TTTimeService : NSObject

@property (nonatomic, strong) TTTime *redLineTTime;

@property (nonatomic, strong) TTTime *blueLineTTime;

@property (nonatomic, strong) TTTime *greenLineTTime;

@property (nonatomic, strong) TTTime *orangeLineTTime;

- (void)updateTTimesForLocation:(CLLocation *)location onCompletion:(TTBlock)complete;

+ (instancetype)sharedService;

@end
