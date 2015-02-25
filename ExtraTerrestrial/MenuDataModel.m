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
    NSMutableArray *returns = [NSMutableArray arrayWithCapacity:([names count ]) +1 ];
    // Add "front" as first item manually, since it's not provided by the api.
    [returns addObject:@"front"];
    [returns addObjectsFromArray:names];
    return returns;
}


@end
