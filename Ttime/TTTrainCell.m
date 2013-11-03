//
//  TTTrainCell.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTrainCell.h"

@implementation TTTrainCell



-(void)setTrains:(NSArray *)trains forDirection:(BOOL)inbound andColor:(UIColor *)color
{
    //self.trains = trains;
    //self.inbound = inbound;
    //self.color = color;
    self.trainCollectionViewController.color = color;
    self.trainCollectionViewController.inbound = inbound;
    [self.trainCollectionViewController setTrains:trains];
}



@end
