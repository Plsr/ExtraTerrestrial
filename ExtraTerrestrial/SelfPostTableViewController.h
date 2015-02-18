//
//  SelfPostTableViewController.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 13/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinglePostAPICall.h"
#import "ContentTableViewCell.h"
#import <MMMarkdown/MMMarkdown.h>

@interface SelfPostTableViewController : UITableViewController

@property (strong, nonatomic) NSString *postURLString;
@property  BOOL isSelf;

@property (strong, nonatomic) NSDictionary *postData;

@end
