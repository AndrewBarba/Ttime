//
//  TTMBTAObject.h
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMBTAObject : NSObject

@property (nonatomic, strong) NSString *id;

+ (instancetype)mbtaObjectFromDictionary:(NSDictionary *)dictionary;

+ (NSString *)uniqueIdentifier;

@end
