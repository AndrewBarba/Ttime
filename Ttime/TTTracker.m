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

- (void)trackEvent:(NSString *)event withName:(NSString *)name
{
    [_gaiTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ttime_action"
                                                              action:event
                                                               label:name
                                                               value:nil] build]];
}

- (void)trackPurchase:(NSString *)purchaseID withName:(NSString *)name forValue:(NSNumber *)value
{
    [_gaiTracker send:[[GAIDictionaryBuilder createItemWithTransactionId:purchaseID
                                                                    name:name
                                                                     sku:purchaseID
                                                                category:@"Donations"
                                                                   price:value
                                                                quantity:@1
                                                            currencyCode:@"USD"] build]];
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
