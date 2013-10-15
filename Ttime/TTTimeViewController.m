//
//  TTTimeViewController.m
//  Ttime
//
//  Created by Andrew Barba on 10/15/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTimeViewController.h"
#import "TTLocationManager.h"
#import "TTTimeService.h"
#import "TTMBTAService.h"

@interface TTTimeViewController ()

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic) BOOL inbound;

@end

@implementation TTTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refresh:nil];
}

- (IBAction)refresh:(id)sender
{
    [[TTLocationManager sharedManager] getCurrentLocation:^(CLLocation *location, TTLocationStatus locationStatus){
        self.userLocation = location;
        [self.refreshControl endRefreshing];
    }];
}

- (void)setUserLocation:(CLLocation *)userLocation
{
    _userLocation = userLocation;
    NSLog(@"%@", userLocation);
    [self.tableView reloadData];
}

- (NSArray *)_trainArrayForSection:(NSInteger)section
{
    switch (section) {
        case 0: return [[TTMBTAService sharedService] greenLineTrains];
        case 1: return [[TTMBTAService sharedService] orangeLineTrains];
        case 2: return [[TTMBTAService sharedService] redLineTrains];
        case 3: return [[TTMBTAService sharedService] blueLineTrains];
    }
    
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.userLocation ? 4 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self _trainArrayForSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"loading...";
    cell.detailTextLabel.text = nil;
    
    NSArray *trains = [self _trainArrayForSection:indexPath.section];
    TTTrain *train = trains[indexPath.row];
    TTStop *stop = [train closestStopToLocation:self.userLocation];
    
    [[TTTimeService sharedService] fetchTTimeForStop:stop onCompletion:^(TTTime *ttime, NSError *error){
        if (ttime) {
            cell.textLabel.text = ttime.stop.name;
            cell.detailTextLabel.text = self.inbound ? ttime.stop.train.inboundStation : ttime.stop.train.outboundStation;
        }
    }];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"Green Line";
        case 1: return @"Orange Line";
        case 2: return @"Red Line";
        case 3: return @"Blue Line";
    }
    
    return nil;
}

@end
