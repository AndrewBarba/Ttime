//
//  TTTimeService.m
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTimeService.h"
#import "TTStopService.h"
#import "TTMBTAClient.h"

@implementation TTTimeService

- (void)updateTTimesForLocation:(CLLocation *)location onCompletion:(TTBlock)complete
{
    [self fetchRedLineTTime:location onComplettion:^(TTTime *time, NSError *error){
        [self fetchOrangeLineTTime:location onComplettion:^(TTTime *time, NSError *error){
            [self fetchBlueLineTTime:location onComplettion:^(TTTime *time, NSError *error){
                [self fetchGreenLineTTime:location onComplettion:^(TTTime *time, NSError *error){
                    if (complete) {
                        complete();
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:TTUpdatedTimeNotificationKey object:self];
                }];
            }];
        }];
    }];
}

#pragma mark - Fetch TTime

- (void)fetchRedLineTTime:(CLLocation *)location onComplettion:(TTTimeBlock)complete
{
    [self fetchTTime:location forLine:TTLineRed onComplettion:complete];
}

- (void)fetchBlueLineTTime:(CLLocation *)location onComplettion:(TTTimeBlock)complete
{
    [self fetchTTime:location forLine:TTLineBlue onComplettion:complete];
}

- (void)fetchOrangeLineTTime:(CLLocation *)location onComplettion:(TTTimeBlock)complete
{
    [self fetchTTime:location forLine:TTLineOrange onComplettion:complete];
}

- (void)fetchGreenLineTTime:(CLLocation *)location onComplettion:(TTTimeBlock)complete
{
    [self fetchTTime:location forLine:TTLineGreen onComplettion:complete];
}

- (void)fetchTTime:(CLLocation *)location forLine:(TTLine)line onComplettion:(TTTimeBlock)complete
{
    TTStop *stop = [[TTStopService sharedService] closestStopOnLine:line toLocation:location];
    
    [self fetchTTimesForStop:stop onCompletion:^(NSArray *ttimes, NSError *error){
        if (ttimes && !error) {
            __block TTTime *myTime = nil;
            [ttimes enumerateObjectsUsingBlock:^(TTTime *time, NSUInteger index, BOOL *done){
                time.location = location;
                [self setTTime:time forLine:line];
                if (time.line == line) {
                    myTime = time;
                    *done = YES;
                }
            }];
            if (complete) {
                complete(myTime, nil);
            }
        } else {
            if (complete) {
                complete(nil, error);
            }
        }
    }];
}

- (void)setTTime:(TTTime *)ttime forLine:(TTLine)line
{
    switch (line) {
        case TTLineRed:
            self.redLineTTime = ttime;
            break;
            
        case TTLineBlue:
            self.blueLineTTime = ttime;
            break;
            
        case TTLineOrange:
            self.orangeLineTTime = ttime;
            break;
            
        case TTLineGreen:
            self.greenLineTTime = ttime;
            break;
            
        case TTLineUnknown:
            // something went wrong...
            break;
    }
}

#pragma mark - Fetch Times

- (void)fetchTTimesForStop:(TTStop *)stop onCompletion:(TTTimesBlock)complete
{
    NSDictionary *params = @{ @"stop" : stop.id };
    [TTMBTAClient asyncMBTARequest:@"/schedulebystop" data:params completion:^(NSDictionary *schedule, NSError *error){
        if (schedule && !error) {
            NSMutableArray *times = [NSMutableArray array];
            for (NSDictionary *mode in schedule[@"mode"]) {
                if ([mode[@"mode_name"] isEqualToString:TTModeSubway]) {
                    for (NSDictionary *route in mode[@"route"]) {
                        TTTime *time = [TTTime mbtaObjectFromDictionary:route];
                        time.stop = stop;
                        [times addObject:time];
                    }
                }
            }
            if (complete) {
                complete(times, nil);
            }
        } else {
            if (complete) {
                complete(nil, error);
            }
        }
    }];
}

#pragma mark - Initialization

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        // setup
    }
    return self;
}

+ (instancetype)sharedService
{
    static id manager = nil;
    TT_DISPATCH_ONCE(^{
        manager = [[self alloc] _initPrivate];
    });
    return manager;
}

@end
