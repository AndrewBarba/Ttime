//
//  TTTracker.h
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TT_TRACK(a,b) \
        [[TTTracker sharedTracker] trackEvent:(a) forAction:NSStringFromSelector(_cmd) withName:(b)]

@interface TTTracker : NSObject

- (void)trackScreenWithName:(NSString *)name;

- (void)trackEvent:(NSString *)event withName:(NSString *)name;

- (void)trackPurchase:(NSString *)purchaseID withName:(NSString *)name forValue:(NSNumber *)value;

+ (instancetype)sharedTracker;

@end
