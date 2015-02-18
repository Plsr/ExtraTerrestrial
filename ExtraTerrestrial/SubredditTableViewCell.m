//
//  FrontPageTableViewCell.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 11/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SubredditTableViewCell.h"

@implementation SubredditTableViewCell

@synthesize titleLabel, subredditLabel, destinationLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
