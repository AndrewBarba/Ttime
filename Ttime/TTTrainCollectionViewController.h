//
//  TTTrainCollectionViewController.h
//  Ttime
//
//  Created by Andrew Barba on 10/21/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTrainCollectionViewController : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *trains;

@property (nonatomic) BOOL inbound;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;


@end
