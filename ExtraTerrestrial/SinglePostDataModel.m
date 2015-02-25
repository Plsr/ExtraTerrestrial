//
//  SinglePostAPICall.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 12/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SinglePostDataModel.h"

@implementation SinglePostDataModel

-(instancetype)initWithURL:(NSURL *)theURL {
    self = [super init];
    if(self) {
        RedditAPICall *apiCall = [[RedditAPICall alloc] init];
        _apiCallReturns = [apiCall arrayWithDataForURL:theURL];
    }
    
    return self;
}



-(NSDictionary *)postContentForKeys:(NSArray *)theKeys {
    NSDictionary *postData = [[[self.apiCallReturns objectAtIndex:0] objectForKey:@"data"] objectForKey:@"children"];
    // Someone at Apple already wrote the method I need, how convenient.
    return [postData dictionaryWithValuesForKeys:theKeys];
}

@end
