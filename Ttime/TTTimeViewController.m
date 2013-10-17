//
//  TTTimeViewController.m
//  Ttime
//
//  Created by Andrew Barba on 10/15/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTTimeViewController.h"
#import "TTTimeService.h"
#import "TTMBTAService.h"
#import "TTTableViewCell.h"

@interface TTTimeViewController ()

@property (nonatomic) BOOL inbound;

@end

@implementation TTTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inbound = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self uiloop];
}

- (void)uiloop
{
    [self.tableView reloadData];
    TTDispatchAfter(0.25, ^{
        [self uiloop];
    });
}

- (IBAction)_handleSwitch:(UISwitch *)sender
{
    self.inbound = sender.on;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self _trainArrayForSection:section] count];
}

- (TTTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TTCell";
    TTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *trains = [self _trainArrayForSection:indexPath.section];
    TTTrain *train = trains[indexPath.row];
    TTStop *stop = [train closestStopToLocation:[[TTLocationManager sharedManager] currentLocation]];
    
    [self updateCell:cell forTTime:stop.ttime];
    
    return cell;
}

- (void)updateCell:(TTTableViewCell *)cell forTTime:(TTTime *)ttime
{
    if (ttime) {
        cell.ttime = ttime;
        cell.stationLabel.text = [NSString stringWithFormat:@"%@", ttime.stop.name];
        [cell.timeButton setTitle:[NSString stringWithFormat:@"%@", [self timeTillDeparture:ttime atIndex:cell.currentIndex]]
                         forState:UIControlStateNormal];
        cell.destinationLabel.text = [NSString stringWithFormat:@"%@",
                                      self.inbound ? ttime.stop.train.inboundStation : ttime.stop.train.outboundStation];
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@",
                                   [self distanceToStop:ttime.stop]];
         
    } else {
        [cell.timeButton setTitle:@"..." forState:UIControlStateNormal];
        cell.stationLabel.text = @"loading...";
    }
    [cell layoutSubviews];
}

- (NSString *)timeTillDeparture:(TTTime *)ttime atIndex:(NSInteger *)index
{
    NSTimeInterval seconds = self.inbound ? [ttime secondsToInboundDeparture:index] : [ttime secondsToOutboundDeparture:index];
    if (seconds <= 0) return @"Loading...";
    
    if (seconds < 60) {
        return [NSString stringWithFormat:@"%i sec", (int)seconds];
    }
    
    NSInteger min = (int)(seconds / 60);
    NSString *string = [NSString stringWithFormat:@"%li min", (long)min];
    if (min > 1) string = [string stringByAppendingString:@"s"];
    return string;
}

-(NSString *)distanceToStop:(TTStop *)stop
{
    CLLocationDistance distance = [stop distanceFromLocation:
                       [[TTLocationManager sharedManager] currentLocation]];
    distance = distance * 0.000621371;
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:distance]];
    
}

@end
