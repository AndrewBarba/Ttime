//
//  TTMBTAService.m
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAService.h"

@interface TTMBTAService() {
    NSArray *_redLineTrains;
    NSArray *_greenLineTrains;
    NSArray *_blueLineTrains;
    NSArray *_orangeLineTrains;
}

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

#pragma mark - Load Data

- (NSArray *)_trainArrayForKey:(NSString *)key
{
    if ([key isEqualToString:@"red"])    return _redLineTrains;
    if ([key isEqualToString:@"orange"]) return _orangeLineTrains;
    if ([key isEqualToString:@"blue"])   return _blueLineTrains;
    if ([key isEqualToString:@"green"])  return _greenLineTrains;
    
    return nil;
}

- (void)_initData:(NSDictionary *)data
{
    [data enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *trainsArray, BOOL *done){
        NSArray *_trainArray = [self _trainArrayForKey:key];
        NSMutableArray *trains = [NSMutableArray array];
        [trainsArray enumerateObjectsUsingBlock:^(NSDictionary *trainDict, NSUInteger index, BOOL *stop){
            TTTrain *train = [TTTrain mbtaObjectFromDictionary:trainDict];
            [trains addObject:train];
        }];
        _trainArray = trains;
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
