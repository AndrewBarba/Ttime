//
//  TTDispatch.m
//  Ttime
//
//  Created by Andrew Barba on 9/24/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTDispatch.h"

@implementation TTDispatch

void TTDispatchMain(TTBlock block)
{
    dispatch_async(dispatch_get_main_queue(),block);
}

void TTDispatchAfter(float after, TTBlock block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, after * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}

void TTDispatchBackground(TTBlock block)
{
    static NSUInteger count = 1;
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue,block);
    count++;
}

@end
