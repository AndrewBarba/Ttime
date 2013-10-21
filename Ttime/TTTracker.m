//
//  TTTracker.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTracker.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface TTTracker() {
    id <GAITracker> _gaiTracker;
}

@end

@implementation TTTracker

- (void)trackScreenWithName:(NSString *)name
{
    [_gaiTracker send:[[[GAIDictionaryBuilder createAppView] set:name
                                                          forKey:kGAIScreenName] build]];
}

- (void)trackEvent:(NSString *)event forAction:(NSString *)action withName:(NSString *)name
{
    [_gaiTracker send:[[GAIDictionaryBuilder createEventWithCategory:event         // Event category (required)
                                                              action:action        // Event action (required)
                                                               label:name          // Event label
                                                               value:nil] build]];
}

#pragma mark - Initialization

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        
        // Google Analytics
        [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
        [[GAI sharedInstance] setDispatchInterval:5];
        
        // Setup Tracker
        _gaiTracker = [[GAI sharedInstance] trackerWithTrackingId:TT_GOOGLE_ANALYTICS_ID];
    }
    return self;
}

+ (instancetype)sharedTracker
{
    static id instance = nil;
    TT_DISPATCH_ONCE(^{
        instance = [[self alloc] _initPrivate];
    });
    return instance;
}

@end
