//
//  ViewController.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 21/01/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedditAPICall.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) RedditAPICall *redditDataConnection;
@property (strong, nonatomic) NSArray *payload;



@end

