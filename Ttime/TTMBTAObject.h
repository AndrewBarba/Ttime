//
//  TTMBTAObject.h
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const TTModeSubway = @"Subway";

typedef NS_ENUM(NSInteger, TTDirection) {
    TTDirectionUnknown = -1,
    TTDirectionOutbound = 0,
    TTDirectionInbound  = 1
};

typedef NS_ENUM(NSInteger, TTLine) {
    TTLineUnknown = 0,
    TTLineGreen,
    TTLineRed,
    TTLineBlue,
    TTLineOrange
};

@interface TTMBTAObject : NSObject

@property (nonatomic, strong) NSString *id;

+ (instancetype)mbtaObjectFromDictionary:(NSDictionary *)dict;

+ (NSString *)uniqueIdentifier;

@end
