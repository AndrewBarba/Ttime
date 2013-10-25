//
//  TTTrainCollectionViewFlowLayout.m
//  Ttime
//
//  Created by Andrew Barba on 10/23/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTrainCollectionViewFlowLayout.h"

@implementation TTTrainCollectionViewFlowLayout

- (void)prepareLayout
{
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0.0;
    self.minimumInteritemSpacing = 0.0;
    self.itemSize = self.collectionView.bounds.size;
}

@end
