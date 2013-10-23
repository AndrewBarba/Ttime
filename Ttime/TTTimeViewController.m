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
#import "TTTrainCell.h"

@interface TTTimeViewController ()

@property (nonatomic) BOOL inbound;

@end

@implementation TTTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
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
    [self setInbound:sender.on];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height / 5;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



- (TTTrainCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TTTrainCell";
    TTTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSArray *trains = [self _trainArrayForSection:indexPath.section];
    
#warning This is bad because you're saying that we HAVE to set inbound before you can set trains. \
         lets make a method for the cell like [cell setTrains:trains forDirection:_inbound]
    cell.inbound = _inbound;
    cell.trains = trains;
    
    
    return cell;
}


@end
