//
//  NSDictionary+TT.h
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TT)

- (BOOL)containsNonEmptyJSONValueForKey:(NSString *)key;

@end
