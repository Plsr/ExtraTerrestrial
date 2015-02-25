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

@property (strong, nonatomic) NSArray *apiCallReturns;

-(instancetype) init __attribute__((unavailable("APICall must always be initialized with an URL"))); // Compile Error for init
-(instancetype) initWithURL: (NSURL *) theURL;

-(NSDictionary *) postContentForKeys: (NSArray *) theKeys;
@end
