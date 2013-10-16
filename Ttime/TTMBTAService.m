//
//  TTMBTAService.m
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAService.h"
#import "TTTimeService.h"
#import "TTMBTAClient.h"

@interface TTMBTAService() {
    NSArray *_redLineTrains;
    NSArray *_greenLineTrains;
    NSArray *_blueLineTrains;
    NSArray *_orangeLineTrains;
    NSArray *_silverLineTrains;
    
    BOOL _isUpdatingData;
}

@property (nonatomic, strong) CLLocation *lastKnownLocation;

@end

@implementation TTMBTAService

- (NSArray *)redLineTrains
{
    return _redLineTrains;
}

- (NSArray *)greenLineTrains
{
    return _greenLineTrains;
}

- (NSArray *)blueLineTrains
{
    return _blueLineTrains;
}

- (NSArray *)orangeLineTrains
{
    return _orangeLineTrains;
}

- (NSArray *)silverLineTrains
{
    return _silverLineTrains;
}

- (void)sortTrains
{
    NSComparator comp = ^NSComparisonResult(TTTrain *t1, TTTrain *t2) {
        CLLocation *location = [[TTLocationManager sharedManager] currentLocation];
        return [t1 distanceToClosestStop:location] - [t2 distanceToClosestStop:location];
    };
    
    _redLineTrains    = [_redLineTrains sortedArrayUsingComparator:comp];
    _blueLineTrains   = [_blueLineTrains sortedArrayUsingComparator:comp];
    _orangeLineTrains = [_orangeLineTrains sortedArrayUsingComparator:comp];
    _greenLineTrains  = [_greenLineTrains sortedArrayUsingComparator:comp];
    _silverLineTrains = [_silverLineTrains sortedArrayUsingComparator:comp];
}

#pragma mark - Update Data

- (void)_handleCurrentLocationChanged:(NSNotification *)notification
{
    [self sortTrains];
    [self startUpdatingData];
}

- (void)startUpdatingData
{
    CLLocation *location = [[TTLocationManager sharedManager] currentLocation];
    
    if (location && !_isUpdatingData) {
        _isUpdatingData = YES;
        [self _updateData];
    }
}

- (void)stopUpdatingData
{
    _isUpdatingData = NO;
}

- (void)_updateData
{
    if (_isUpdatingData) {
        [self updateAllData:^{
            TTDispatchAfter(5.0, ^{
                [self _updateData];
            });
        }];
    }
}

- (void)updateAllData:(TTBlock)complete
{
    CLLocation *location = [[TTLocationManager sharedManager] currentLocation];
    
    if (!location) {
        if (complete) {
            complete();
        }
        return;
    }
    
    NSArray *lines = @[ _greenLineTrains, _orangeLineTrains, _redLineTrains, _blueLineTrains, _silverLineTrains ];
    
    NSMutableArray *stops = [NSMutableArray array];
    
    for (NSArray *line in lines) {
        for (TTTrain *train in line) {
            TTStop *stop = [train closestStopToLocation:location];
            [stops addObject:stop];
        }
    }
    
    __block NSUInteger remaining = stops.count;
    
    for (TTStop *stop in stops) {
        [[TTTimeService sharedService] fetchTTimeForStop:stop onCompletion:^(TTTime *time, NSError *error){
            remaining--;
            if (remaining == 0 && complete) {
                complete();
            }
        }];
    }
}

#pragma mark - Load Data

- (void)_setTrainArray:(NSArray *)trains forKey:(NSString *)key
{
    if ([key isEqualToString:@"red"])    _redLineTrains = trains;
    if ([key isEqualToString:@"orange"]) _orangeLineTrains = trains;
    if ([key isEqualToString:@"blue"])   _blueLineTrains = trains;
    if ([key isEqualToString:@"green"])  _greenLineTrains = trains;
    if ([key isEqualToString:@"silver"]) _silverLineTrains = trains;
}

- (void)_initData:(NSDictionary *)data
{
    [data enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *trainsArray, BOOL *done){
        NSMutableArray *trains = [NSMutableArray array];
        [trainsArray enumerateObjectsUsingBlock:^(NSDictionary *trainDict, NSUInteger index, BOOL *stop){
            TTTrain *train = [TTTrain mbtaObjectFromDictionary:trainDict];
            [trains addObject:train];
        }];
        [self _setTrainArray:trains forKey:key];
    }];
}

#pragma mark - Initialization

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [self _initData:dict];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_handleCurrentLocationChanged:)
                                                     name:TTCurrentLocationChangedNotificationKey
                                                   object:nil];
    }
    return self;
}

+ (instancetype)sharedService
{
    static id service = nil;
    TT_DISPATCH_ONCE(^{
        service = [[self alloc] _initPrivate];
    });
    return service;
}

@end
