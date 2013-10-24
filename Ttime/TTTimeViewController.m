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

@interface TTTimeViewController ()

@property (nonatomic) BOOL inbound;

@end

@implementation TTTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.navigationItem.title = @"TTIME";
    
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



- (IBAction)switchInbound:(id)sender
{
    if (_inbound)
    {
        [_inboundButton setTitle:@"Inbound" forState:UIControlStateNormal];
        _inbound = !_inbound;
    } else {
        [_inboundButton setTitle:@"Outbound" forState:UIControlStateNormal];
        _inbound = !_inbound;
    }
    [self.tableView reloadData];

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


//watch wwdc autolayout video



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    return (screenHeight - 64) / 5;
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
    
#warning This is bad because you're saying that we HAVE to set inbound before you can set trains. \
         lets make a method for the cell like [cell setTrains:trains forDirection:_inbound]
    
    switch (indexPath.row)
    {
        case 0: [cell setTrains:trains forDirection:_inbound andColor:[UIColor greenLineColor]];
            
        case 1: [cell setTrains:trains forDirection:_inbound andColor:[UIColor orangeLineColor]];
            
        case 2: [cell setTrains:trains forDirection:_inbound andColor:[UIColor redLineColor]];
            
        case 3: [cell setTrains:trains forDirection:_inbound andColor:[UIColor blueLineColor]];
            
        case 4: [cell setTrains:trains forDirection:_inbound andColor:[UIColor silverLineColor]];
    }

    return cell;
}


@end
