//
//  ForntPageTableViewController.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 10/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedditAPICall.h"

@interface ForntPageTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *FrontPageTableView;

@property RedditAPICall *apiCall;

@end
