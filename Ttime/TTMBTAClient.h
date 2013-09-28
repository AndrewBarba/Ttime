//
//  TTMBTAClient.h
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TT_MBTA_BASE_URL @"http://realtime.mbta.com/developer/api/v1"

@interface TTMBTAClient : NSObject

+ (instancetype)sharedClient;

@end
