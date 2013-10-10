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

- (TTStop *)closestStopOnLine:(TTLine)line toLocation:(CLLocation *)location
{
    TTStop *closest = nil;
    CLLocationDistance closestDistance = NSIntegerMax;
    
    NSArray *stops = [self stopsForLine:line];
    
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
    return [self closestStopOnLine:TTLineRed toLocation:location];
}

- (TTStop *)closestBlueLineStop:(CLLocation *)location
{
    return [self closestStopOnLine:TTLineBlue toLocation:location];
}

- (TTStop *)closestOrangeLineStop:(CLLocation *)location
{
    return [self closestStopOnLine:TTLineOrange toLocation:location];
}

- (TTStop *)closestGreenLineStop:(CLLocation *)location
{
    return [self closestStopOnLine:TTLineGreen toLocation:location];
}

#pragma mark - Stops

- (NSArray *)stopsForLine:(TTLine)line
{
    switch (line) {
        case TTLineRed: return [self.lines objectForKey:@"red"];
        case TTLineOrange: return [self.lines objectForKey:@"orange"];
        case TTLineBlue: return [self.lines objectForKey:@"blue"];
        case TTLineGreen: return [self.lines objectForKey:@"green"];
        case TTLineUnknown: return nil;
    }
}

- (NSArray *)redLineStops
{
    return [self stopsForLine:TTLineRed];
}

- (NSArray *)orangeLineStops
{
    return [self stopsForLine:TTLineOrange];
}

- (NSArray *)blueLineStops
{
    return [self stopsForLine:TTLineBlue];
}

- (NSArray *)greenLineStops
{
    return [self stopsForLine:TTLineGreen];
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
