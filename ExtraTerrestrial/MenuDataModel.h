//
//  UserAPICall.h
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 24/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedditAPICall.h"

@interface MenuDataModel : NSObject

@property (strong, nonatomic) NSDictionary* apiCallReturns;
@property (strong, nonatomic) NSString* before;
@property (strong, nonatomic) NSString* after;


-(instancetype) init __attribute__((unavailable("APICall must always be initialized with an URL"))); // Compile Error for init
-(instancetype) initWithURL: (NSURL *) theURL;
-(NSArray *) subredditNames;


@end
