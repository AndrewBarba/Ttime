//
//  TTDonationService.h
//  Ttime
//
//  Created by Andrew Barba on 10/27/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

static NSString *const TTDonationSmallKey  = @"com.abarba.ttime.small";
static NSString *const TTDonationMediumKey = @"com.abarba.ttime.medium";
static NSString *const TTDonationLargeKey  = @"com.abarba.ttime.large";

static NSString *const TTDonationReadyStateChangedNotificationKey  = @"TTDonationReadyStateChangedNotification";

typedef void(^TTDonationBlock)(BOOL success, NSError *error);

@interface TTDonationService : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

/**
 * Makes a donation for one of the types listed above
 * Small  = $0.99
 * Medium = $2.99
 * Large  = $4.99
 */
- (void)makeDonation:(NSString *)donationType onCompletion:(TTDonationBlock)complete;

/**
 * Determines if we can currently make a donation
 * If NO, call refresh products and wait for the products refreshed notification
 */
- (BOOL)canMakeDonation;

/**
 * Refreshes a list of available purchases
 * Posts notification when updated
 */
- (void)refreshProducts;

+ (instancetype)sharedInstance;

@end
