//
//  SinglePostAPICall.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 12/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedditAPICall.h"

@interface SinglePostDataModel : NSObject

@property (strong, nonatomic) NSDictionary *apiCallReturns;

-(instancetype) init __attribute__((unavailable("APICall must always be initialized with an URL"))); // Compile Error for init
-(instancetype) initWithURL: (NSURL *) theURL;

-(NSArray *) commentsFromDataModel;

@end
