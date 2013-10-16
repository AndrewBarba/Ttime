//
//  TTMBTAService.h
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMBTAService : NSObject

- (NSArray *)greenLineTrains;

- (NSArray *)redLineTrains;

- (NSArray *)orangeLineTrains;

- (NSArray *)blueLineTrains;

- (NSArray *)silverLineTrains;

- (void)startUpdatingData;

- (void)stopUpdatingData;

+ (instancetype)sharedService;

@end
