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

@interface TTTrainCollectionViewController ()



@end

@implementation TTTrainCollectionViewController


- (void)uiloop
{
    [self.collectionView reloadData];
    TTDispatchAfter(0.25, ^{
        [self uiloop];
    });
}

-(void)setTrains:(NSArray *)trains
{
    if (_trains != trains) {
        _trains = trains;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        //[self uiloop];
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
    static NSString *identifier = @"TTCollectionCell";
    TTCollectionLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    TTTrain *train = _trains[indexPath.row];
    TTStop *stop = [train closestStopToLocation:[[TTLocationManager sharedManager] currentLocation]];
    
    [self updateCell:cell forStop:stop];
    return cell;
}




- (void)updateCell:(TTCollectionLineCell *)cell forStop:(TTStop *)stop
{
#warning this logic should not be here! We have a cell subclass so just set the ttime on the cell and let the cell handle it own layout
    cell.stopLabel.text = [NSString stringWithFormat:@"%@", stop.name];
    [cell.timeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    cell.destinationLabel.text = [NSString stringWithFormat:@"%@",
                                 self.inbound ? stop.train.inboundStation : stop.train.outboundStation];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@",
                               [self distanceToStop:stop]];
    
    
    
    if (stop.ttime) {
        cell.ttime = stop.ttime;
        [cell.timeButton setTitle:[NSString stringWithFormat:@"%@", [self timeTillDeparture:stop.ttime atIndex:0]]
                         forState:UIControlStateNormal];
    } else {
        [cell.timeButton setTitle:@"..." forState:UIControlStateNormal];
    }
}




- (NSString *)timeTillDeparture:(TTTime *)ttime atIndex:(NSInteger *)index
{
#warning This will not be needed once you start using my custom TTCircleTimeView
    NSTimeInterval seconds;
    
    if (self.inbound)
    {
        seconds = [ttime secondsToInboundDeparture:0];
    } else {
        seconds = [ttime secondsToOutboundDeparture:0];
    }
    
    if (seconds < 1) return @"...";
    
    if (seconds < 60) {
        return [NSString stringWithFormat:@"%i\nsec", (int)seconds];
    }
    
    NSInteger min = (int)(seconds / 60);
    NSString *string = [NSString stringWithFormat:@"%li\nmin", (long)min];
    return string;
}

-(NSString *)distanceToStop:(TTStop *)stop
{
#warning I dont like this logic. Lets move this to a class thats more suited to returning this kind of info. \
         It's fine that this method returns a string but there should be a method somewhere else that converts meters to miles
    CLLocationDistance distance = [stop distanceFromLocation:
                                   [[TTLocationManager sharedManager] currentLocation]];
    distance = distance * 0.000621371;
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:distance]];
    
}




@end
