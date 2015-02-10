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



-(instancetype) initWithURL: (NSURL *) theURL;
-(NSArray *) dataForKey: (NSString *) theKey;


@end
