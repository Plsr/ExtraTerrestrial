//
//  UserAPICall.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 24/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "MenuDataModel.h"

@implementation MenuDataModel


/**
 *  Creates a MenuDataModel object with the contents of an API-Call for an URL
 *
 *  @param theURL The URL to use for the request
 *
 *  @return MenuDataModel Object with an NSDictionary containing the returns of the request
 *
 *  @note theURL must be of the format http://www.reddit.com/reddits.json for the function to work properly
 *
 */
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


/**
 *  Creates an Array with the names of the subreddits that are popular right now
 *
 *  @return Array with the names of the subreddits
 *
 *  @note   "front" is alwazs added as first element of the array by this function, because it's not provided by the API
 */
-(NSArray *) subredditNames {
    NSArray* names = [[[[self.apiCallReturns valueForKey:@"data"] valueForKey:@"children"] valueForKey:@"data"] valueForKey:@"display_name"];
    NSMutableArray *returns = [NSMutableArray arrayWithCapacity:([names count ]) +1 ];
    // Add "front" as first item manually, since it's not provided by the api.
    [returns addObject:@"front"];
    [returns addObjectsFromArray:names];
    return returns;
}


@end
