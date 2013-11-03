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

@interface TTTrainCollectionViewController () {
    NSTimer *_updateTimer;
}

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

- (void)setColor:(UIColor *)color
{
    if (_color != color) {
        _color = color;
        self.pageControl.currentPageIndicatorTintColor = color;
    }
}


-(void)setTrains:(NSArray *)trains
{
    if (_trains != trains) {
        _trains = trains;
        self.collectionView.pagingEnabled = YES;
        self.pageControl.numberOfPages = trains.count;
        [self.collectionView reloadData];
        [self _setupTimer];
    }
}

- (void)_setupTimer
{
    if (_updateTimer) {
        [_updateTimer invalidate];
        _updateTimer = nil;
    }
    
    _updateTimer = [NSTimer timerWithTimeInterval:0.15 target:self selector:@selector(_update:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_updateTimer forMode:NSRunLoopCommonModes];
}

- (void)dealloc
{
    [_updateTimer invalidate];
    _updateTimer = nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (self.collectionView.contentSize.width <= self.collectionView.frame.size.width) {
    } else {
        NSInteger page = MAX(0.0, self.collectionView.contentOffset.x
                             / self.collectionView.frame.size.width);
        self.pageControl.currentPage = page;
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

- (void)_update:(NSTimer *)timer
{
    [_trains enumerateObjectsUsingBlock:^(TTTrain *train, NSUInteger index, BOOL *done){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        TTCollectionLineCell *cell = (TTCollectionLineCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        TTStop *stop = [train closestStopToLocation:[[TTLocationManager sharedManager] currentLocation]];
        [cell updateCell:stop forInbound:self.inbound andColor:self.color];
    }];
}

@end
