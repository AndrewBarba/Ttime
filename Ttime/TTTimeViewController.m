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
    
    self.inbound = YES;

    [self refresh:nil];
}

- (IBAction)_handleSwitch:(UISwitch *)sender
{
    self.inbound = sender.on;
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

- (void)setInbound:(BOOL)inbound
{
    if (_inbound != inbound) {
        _inbound = inbound;
        self.title = _inbound ? @"Inbound" : @"Outbound";
        [self.tableView reloadData];
    }
}

- (NSArray *)_trainArrayForSection:(NSInteger)section
{
    switch (section) {
        case 0: return [[TTMBTAService sharedService] greenLineTrains];
        case 1: return [[TTMBTAService sharedService] orangeLineTrains];
        case 2: return [[TTMBTAService sharedService] redLineTrains];
        case 3: return [[TTMBTAService sharedService] blueLineTrains];
        case 4: return [[TTMBTAService sharedService] silverLineTrains];
    }
    
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.userLocation ? 5 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self _trainArrayForSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    I'm commenting out these lines for now because I'm too lazy too subclass a cell. This should be uncommented at somepoint
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // This is bad. At some point we should use the above but I'm lazy and using this for now
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = @"loading...";
    cell.detailTextLabel.text = nil;
    
    NSArray *trains = [self _trainArrayForSection:indexPath.section];
    TTTrain *train = trains[indexPath.row];
    TTStop *stop = [train closestStopToLocation:self.userLocation];
    
    [[TTTimeService sharedService] fetchTTimeForStop:stop onCompletion:^(TTTime *ttime, NSError *error){
        if (ttime) {
            stop.ttime = ttime;
            [self updateCell:cell forTTime:ttime];
        }
    }];
    
    if (stop.ttime) {
        [self updateCell:cell forTTime:stop.ttime];
    }
    
    return cell;
}

- (void)updateCell:(UITableViewCell *)cell forTTime:(TTTime *)ttime
{
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", ttime.stop.name, [self timeTillDeparture:ttime]];
    cell.detailTextLabel.text =
    [NSString stringWithFormat:@"%@ > %@", ttime.stop.train.name,
     self.inbound ? ttime.stop.train.inboundStation : ttime.stop.train.outboundStation];
    [cell layoutSubviews];
}

- (NSString *)timeTillDeparture:(TTTime *)ttime
{
    NSDate *date = self.inbound ? ttime.inboundDepartureDate : ttime.outboundDepartureDate;
    NSTimeInterval seconds = [date timeIntervalSinceDate:[NSDate date]];
    if (seconds <= 0) return @"Loading...";
    
    if (seconds < 60) {
        return [NSString stringWithFormat:@"%i seconds", (int)seconds];
    }
    
    NSInteger min = (int)(seconds / 60);
    NSString *string = [NSString stringWithFormat:@"%li minute", (long)min];
    if (min > 1) string = [string stringByAppendingString:@"s"];
    return string;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"Green Line";
        case 1: return @"Orange Line";
        case 2: return @"Red Line";
        case 3: return @"Blue Line";
        case 4: return @"Silver Line";
    }
    
    return nil;
}

@end
