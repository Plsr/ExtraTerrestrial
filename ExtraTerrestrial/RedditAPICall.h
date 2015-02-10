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
@property (strong, nonatomic) NSDictionary *apiCallReturns;

//Use dictionary?
//@property (strong, nonatomic) NSDictionary *payload;

-(instancetype) initWithURL: (NSURL *) theURL;


//-(NSArray *) returnNthLevelOfPayload: (int) level;
-(NSArray *) returnDataForKeyChildren;
-(NSArray *) dataForKey: (NSString *) theKey;


@end
