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
- (void)setTrain:(TTTrain *)train
{
    if (_train != train) {
        _train = train;
        self.trainCollectionViewController.train = _train;
    }
}

@end
