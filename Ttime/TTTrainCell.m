//
//  TTTrainCell.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTrainCell.h"

@implementation TTTrainCell

// Anytime someone sets out Train object
// pass it down to our collection view controller
- (void)setTrains:(NSArray *)trains 
{
    if (_trains != trains) {
        
        _trains = trains;
        _trainCollectionViewController.inbound = _inbound;
        [_trainCollectionViewController setTrains:trains];
        
    }
}


-(void)setTrains:(NSArray *)trains forDirection:(BOOL)inbound andColor:(UIColor *)color
{
    self.trains = trains;
    self.inbound = inbound;
    self.trainCollectionViewController.color = color;
    self.trainCollectionViewController.inbound = _inbound;
    [_trainCollectionViewController setTrains:trains];
    
}



@end
