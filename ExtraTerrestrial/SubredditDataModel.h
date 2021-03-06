//
//  RedditDataFetcher.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 23/01/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RedditAPICall.h"

@interface SubredditDataModel : NSObject

@property (strong, nonatomic) NSString *before;
@property (strong, nonatomic) NSString *after;
@property (strong, nonatomic) NSDictionary *payload;



-(instancetype) initWithURL: (NSURL *) theURL;
-(NSArray *) contentOfChildrenForKeys: (NSArray *) theKeys;

@end
