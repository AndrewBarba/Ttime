//
//  TTMBTAObject.m
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAObject.h"

@implementation TTMBTAObject

+ (id)mbtaObjectFromDictionary:(NSDictionary *)dictionary
{
    TTMBTAObject *object = [[self alloc] init];
    
    NSString *identifier = [dictionary objectForKey:[self uniqueIdentifier]];
    
    object.id = identifier;
    
    return object;
}

+ (NSString *)uniqueIdentifier
{
    return @"";
}

@end
