//
//  NSDictionary+TT.m
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "NSDictionary+TT.h"

@implementation NSDictionary (TT)

- (BOOL)containsNonEmptyJSONValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSString * stringValue = (NSString *)value;
        return (stringValue.length > 0);
    }
    return YES;
}

@end
