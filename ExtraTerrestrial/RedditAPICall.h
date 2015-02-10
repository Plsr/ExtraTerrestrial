//
//  RedditDataFetcher.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 23/01/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedditAPICall : NSObject

@property (strong, nonatomic) NSString *before;
@property (strong, nonatomic) NSString *after;

//Use dictionary?
//@property (strong, nonatomic) NSDictionary *payload;

-(NSDictionary *)retrieveDataFromURL: (NSURL*) targetURL;
//-(NSArray *) returnNthLevelOfPayload: (int) level;
-(NSArray *) returnDataForKeyChildren;
-(NSArray *) titlesForURL: (NSURL *) theURL;


@end
