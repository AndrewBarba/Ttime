//
//  TTTimeService.h
//  Ttime
//
//  Created by Andrew Barba on 10/9/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TTTimeBlock) (TTTime *ttime, NSError *error);

@interface TTTimeService : NSObject

- (void)fetchTTimeForStop:(TTStop *)stop onCompletion:(TTTimeBlock)complete;

+ (instancetype)sharedService;

@end
