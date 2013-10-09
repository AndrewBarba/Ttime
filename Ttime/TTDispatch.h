//
//  TTDispatch.h
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>


// TT Completion blocks
typedef void (^TTObjectBlock)         (id object);
typedef void (^TTSetBlock)            (NSSet *set);
typedef void (^TTArrayBlock)          (NSArray *array);
typedef void (^TTDictionaryBlock)     (NSDictionary *dict);
typedef void (^TTIntegerBlock)        (NSInteger number);
typedef void (^TTFloatBlock)          (float number);
typedef void (^TTDoubleBlock)         (double number);
typedef void (^TTBooleanBlock)        (BOOL *yesOrNo);
typedef void (^TTBlock)               ();

@interface TTDispatch : NSObject

/**
 * Dispatches a block on the main thread
 */
void TTDispatchMain(TTBlock block);

/**
 * Dispatches a block on a background thread
 */
void TTDispatchBackground(TTBlock block);

/**
 * Dispatches a block on the main thread after a given number of seconds
 */
void TTDispatchAfter(float after, TTBlock block);

/**
 * Macro used for running a block only once.
 * Must use macro so the static token is dynamically compiled
 * WARNING: cannot use this twice in the same method
 */
#define TT_DISPATCH_ONCE(block) static dispatch_once_t _tt_token; dispatch_once(&_tt_token, block);

@end
