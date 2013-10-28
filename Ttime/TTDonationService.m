//
//  TTDonationService.m
//  Ttime
//
//  Created by Andrew Barba on 10/27/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTDonationService.h"

@interface TTDonationService() {
    NSSet *_productIdentifiers;
    NSMutableDictionary *_products;
    NSMutableDictionary *_completionBlocks;
}

@end

@implementation TTDonationService

- (void)makeDonation:(NSString *)donationType onCompletion:(TTDonationBlock)complete
{
    SKProduct *product = _products[donationType];
    
    if (product) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        _completionBlocks[donationType] = [complete copy];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        if (complete) {
            complete(NO, nil);
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState != SKPaymentTransactionStatePurchasing) {
            NSString *productID = transaction.payment.productIdentifier;
            TTDonationBlock block = _completionBlocks[productID];
            if (block) {
                BOOL success = transaction.transactionState == SKPaymentTransactionStatePurchased;
                block(success, transaction.error);
                [_completionBlocks removeObjectForKey:productID];
            }
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}

- (BOOL)canMakeDonation
{
    return _products != nil;
}

#pragma mark - Products Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for (SKProduct *product in response.products) {
        _products[product.productIdentifier] = product;
    }
    
    NSLog(@"Refreshed products: %@", _products);
    [[NSNotificationCenter defaultCenter] postNotificationName:TTDonationReadyStateChangedNotificationKey object:_products];
}

#pragma mark - Initialization

- (void)refreshProducts
{
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    request.delegate = self;
    [request start];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        _products = [NSMutableDictionary dictionary];
        _completionBlocks = [NSMutableDictionary dictionary];
        _productIdentifiers = [NSSet setWithObjects:
                               TTDonationSmallKey,
                               TTDonationMediumKey,
                               TTDonationLargeKey,
                               nil];        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id instance = nil;
    TT_DISPATCH_ONCE(^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
