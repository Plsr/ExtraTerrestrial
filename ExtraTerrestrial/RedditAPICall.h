//
//  RedditAPICall.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 24/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedditAPICall : NSObject

-(NSDictionary *) dictionaryWithDataForURL:(NSURL *) url;
-(NSArray *) arrayWithDataForURL: (NSURL *) url;

@end
