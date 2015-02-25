//
//  ForntPageTableViewController.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 10/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubredditDataModel.h"
#import "SelfPostTableViewController.h"
#import "LinkPostViewController.h"
#import "SubredditTableViewCell.h"
#import "SubredditTableViewImageCell.h"

@interface SubredditTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *FrontPageTableView;
@property SubredditDataModel *apiCall;
@property NSString *subredditTitle;
@property NSURL *subredditURL;
@property BOOL setFromSegue;


@end
