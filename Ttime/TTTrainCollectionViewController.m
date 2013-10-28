//
//  TTTrainCollectionViewController.m
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTrainCollectionViewController.h"
#import "TTTrainCell.h"
#import "TTCollectionLineCell.h"

static NSString *const TTCellID = @"TTCollectionCell";

@interface TTTrainCollectionViewController ()

@end

@implementation TTTrainCollectionViewController

- (void)setCollectionView:(UICollectionView *)collectionView
{
    if (_collectionView != collectionView) {
        _collectionView = collectionView;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
}

-(void)setTrains:(NSArray *)trains
{
    if (_trains != trains) {
        _trains = trains;
        [self.collectionView reloadData];
        [self _update];
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.trains count];
}

-(TTCollectionLineCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TTCollectionLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TTCellID forIndexPath:indexPath];
    
    TTTrain *train = _trains[indexPath.row];
    TTStop *stop = [train closestStopToLocation:[[TTLocationManager sharedManager] currentLocation]];
    [cell updateCell:stop forInbound:self.inbound andColor:self.color];
    
    return cell;
}

- (void)_update
{
    [_trains enumerateObjectsUsingBlock:^(TTTrain *train, NSUInteger index, BOOL *done){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        TTCollectionLineCell *cell = (TTCollectionLineCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        TTStop *stop = [train closestStopToLocation:[[TTLocationManager sharedManager] currentLocation]];
        [cell updateCell:stop forInbound:self.inbound andColor:self.color];
    }];
    
    __weak TTTrainCollectionViewController *_weakSelf = self;
    
    TTDispatchAfter(0.5, ^{
        [_weakSelf _update];
    });
}

@end
