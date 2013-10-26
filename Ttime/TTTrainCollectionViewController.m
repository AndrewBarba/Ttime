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
//        [_collectionView registerClass:[TTCollectionLineCell class] forCellWithReuseIdentifier:TTCellID];
    }
}

-(void)setTrains:(NSArray *)trains
{
    if (_trains != trains) {
        _trains = trains;
        [self uiloop];
    }
}

- (void)uiloop
{
    [self.collectionView reloadData];
    TTDispatchAfter(0.25, ^{
        [self uiloop];
    });
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



@end
