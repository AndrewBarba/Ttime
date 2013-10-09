//
//  TTStopService.m
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTStopService.h"

@interface TTStopService()

@property (nonatomic, strong) NSDictionary *lines;

@end

@implementation TTStopService

- (TTStop *)closestStop:(NSArray *)stops toLocation:(CLLocation *)location
{
    TTStop *closest = nil;
    CLLocationDistance closestDistance = NSIntegerMax;
    
    for (TTStop *stop in stops) {
        CLLocationDistance distance = [stop distanceFromLocation:location];
        if (distance < closestDistance) {
            closestDistance = distance;
            closest = stop;
        }
    }
    
    return closest;
}

- (TTStop *)closestRedLineStop:(CLLocation *)location
{
    return [self closestStop:[self redLineStops] toLocation:location];
}

- (TTStop *)closestBlueLineStop:(CLLocation *)location
{
    return [self closestStop:[self blueLineStops] toLocation:location];
}

- (TTStop *)closestOrangeLineStop:(CLLocation *)location
{
    return [self closestStop:[self orangeLineStops] toLocation:location];
}

- (TTStop *)closestGreenLineStop:(CLLocation *)location
{
    return [self closestStop:[self greenLineStops] toLocation:location];
}

#pragma mark - Stops

- (NSArray *)stopsForKey:(NSString *)key
{
    return [self.lines objectForKey:key];
}

- (NSArray *)redLineStops
{
    return [self stopsForKey:@"red"];
}

- (NSArray *)orangeLineStops
{
    return [self stopsForKey:@"orange"];
}

- (NSArray *)blueLineStops
{
    return [self stopsForKey:@"blue"];
}

- (NSArray *)greenLineStops
{
    return [self stopsForKey:@"green"];
}

#pragma mark - Initialization

- (void)_initLines:(NSDictionary *)dict
{
    NSMutableDictionary *lines = [NSMutableDictionary dictionary];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *stopsDict, BOOL *stop1){
        NSMutableArray *stops = [NSMutableArray array];
        [stopsDict enumerateKeysAndObjectsUsingBlock:^(NSString *stopName, NSDictionary *stopDict, BOOL *stop2){
            TTStop *stop = [TTStop mbtaObjectFromDictionary:stopDict];
            [stops addObject:stop];
        }];
        lines[key] = stops;
    }];
    
    _lines = lines;
}

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [self _initLines:dict];
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
