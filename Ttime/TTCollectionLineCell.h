//
//  TTCollectionLineCell.h
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTrain.h"
#import "TTCircleTimeView.h"

@interface TTCollectionLineCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet TTCircleTimeView *timeView;

@property (weak, nonatomic) IBOutlet UILabel *stopLabel;

@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

-(void)updateCell:(TTStop *)stop forInbound:(BOOL)inbound andColor:(UIColor *)color;

@end
