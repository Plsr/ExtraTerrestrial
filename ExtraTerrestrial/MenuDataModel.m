//
//  UserAPICall.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 24/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "MenuDataModel.h"

@implementation MenuDataModel

-(instancetype)initWithURL:(NSURL *)theURL {
    self = [super init];
    if(self) {
        RedditAPICall *apiCall = [[RedditAPICall alloc] init];
        _apiCallReturns = [apiCall dictionaryWithDataForURL:theURL];
        _before = [[_apiCallReturns valueForKey:@"data"] valueForKey:@"before"];
        _after = [[_apiCallReturns valueForKey:@"data"] valueForKey:@"after"];
    }
    return self;
}


-(NSArray *) subredditNames {
    NSArray* names = [[[[self.apiCallReturns valueForKey:@"data"] valueForKey:@"children"] valueForKey:@"data"] valueForKey:@"display_name"];
    return names;
}


@end
