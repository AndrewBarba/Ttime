//
//  TTMBTAService.h
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMBTAClient.h"

@interface TTMBTAService : NSObject

- (void)fetchClostestStopsWithLatitude:(float)lat
                             longitude:(float)lon
                          onCompletion:(TTRequestArrayBlock)complete;

+ (instancetype)sharedService;

@end
