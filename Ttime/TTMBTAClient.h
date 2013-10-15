//
//  TTMBTAClient.h
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#define TT_MBTA_BASE_URL @"http://realtime.mbta.com/developer/api/v1"

typedef void (^TTRequestBlock) (id responseObject, NSError *error);
typedef void (^TTRequestArrayBlock) (NSArray *items, NSError *error);
typedef void (^TTRequestDictionaryBlock) (NSDictionary *dict, NSError *error);

@interface TTMBTAClient : NSObject

+ (void)asyncMBTARequest:(NSString *)endpoint
                    data:(NSDictionary *)data
              completion:(TTRequestBlock)complete;

@end
