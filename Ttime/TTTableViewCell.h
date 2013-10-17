//
//  TTTableViewCell.h
//  Ttime
//
//  Created by Zacharia Bachiri on 10/16/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) TTTime *ttime;

- (IBAction)nextTrainTime:(id)sender;


@end
