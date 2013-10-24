//
//  TTTrainCollectionViewFlowLayout.m
//  Ttime
//
//  Created by Andrew Barba on 10/23/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTrainCollectionViewFlowLayout.h"

@implementation TTTrainCollectionViewFlowLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (CGSize)itemSize
{
    return self.collectionView.bounds.size;
}

@end
