//
//  TTTrainCell.h
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTrainCollectionViewController.h"

@interface TTTrainCell : UITableViewCell

// this may need to be weak, we'll find out later
@property (nonatomic, strong) TTTrain *train;

@property (nonatomic, weak) IBOutlet TTTrainCollectionViewController *trainCollectionViewController;

@end
