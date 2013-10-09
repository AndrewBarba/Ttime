//
//  TTStop.h
//  Ttime
//
//  Created by Andrew Barba on 10/8/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTMBTAObject.h"

@interface TTStop : TTMBTAObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic) float latitude;

@property (nonatomic) float longitude;

@property (nonatomic) float distance; // distance in miles

@end
