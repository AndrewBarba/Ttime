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
#import "UIColor+TT.h"
#import "TTDonationService.h"

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
    
    [[TTTracker sharedTracker] trackScreenWithName:@"Main Screen"];
    
    if (TT_IS_IOS7()) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:nil
                                                                                action:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (IBAction)switchInbound:(id)sender
{
    _inbound = !_inbound;
    [_inboundButton setTitle: (_inbound ? @"Inbound" : @"Outbound") forState:UIControlStateNormal];
    [self.tableView reloadData];
    
    [[TTTracker sharedTracker] trackEvent:@"inbound_outbound" withName:@"Toggled Inbound/Outbound"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenHeight = self.view.bounds.size.height;
    return screenHeight / [self tableView:self.tableView numberOfRowsInSection:0];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}



- (TTTrainCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TTTrainCell";
    TTTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *trains = [self _trainArrayForSection:indexPath.row];
    
    switch (indexPath.row)
    {
        case 0: [cell setTrains:trains forDirection:_inbound andColor:[UIColor greenLineColor]]; break;
            
        case 1: [cell setTrains:trains forDirection:_inbound andColor:[UIColor orangeLineColor]]; break;
            
        case 2: [cell setTrains:trains forDirection:_inbound andColor:[UIColor redLineColor]]; break;
            
        case 3: [cell setTrains:trains forDirection:_inbound andColor:[UIColor blueLineColor]]; break;
            
        case 4: [cell setTrains:trains forDirection:_inbound andColor:[UIColor silverLineColor]]; break;
    }

    return cell;
}


@end
