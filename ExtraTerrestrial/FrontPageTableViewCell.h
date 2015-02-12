//
//  FrontPageTableViewCell.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 11/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrontPageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subredditLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

@end
