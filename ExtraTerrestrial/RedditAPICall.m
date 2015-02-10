//
//  RedditDataFetcher.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 23/01/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "RedditAPICall.h"

@implementation RedditAPICall

- (instancetype)init
{
    self = [super init];
    if (self) {
        //_payload = [[NSDictionary alloc] init];
        _before = nil;
        _after = nil;
    }
    return self;
}


//  Perform an API Call
-(NSDictionary *) retrieveDataFromURL:(NSURL *)targetURL {
    
    NSDictionary *requestReturns = [[NSDictionary alloc] init];
    
    //Basic URLRequest
    NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] initWithURL:targetURL];
    getRequest.HTTPMethod = @"GET";
    
    //Set up stuff to send request and retrieve response
    NSURLResponse *getRequestResponse = nil;
    NSError *getRequestError = nil;
    NSData *requestReturnData = [NSURLConnection sendSynchronousRequest:getRequest
                                                      returningResponse:&getRequestResponse
                                                                  error:&getRequestError];
    
    if(!getRequestError) {
        NSError *jsonSerializationError = nil;
        requestReturns = [NSJSONSerialization JSONObjectWithData:requestReturnData
                                                         options:NSUTF8StringEncoding
                                                           error:&jsonSerializationError];
        
        if(!jsonSerializationError) {
            self.before = [[requestReturns valueForKey:@"data"] valueForKey:@"before"];
            self.after = [[requestReturns valueForKey:@"data"] valueForKey:@"after"];
            requestReturns = [[requestReturns valueForKey:@"data"] valueForKey:@"children"];
        }
    }

    return requestReturns;
}

/* May be obsolete later, could be better di directly get the few objects I need
-(NSArray *)returnNthLevelOfPayload: (int) level {
    NSArray *levelData = [[NSArray alloc] init];
    NSArray *allKeys = [self.payload allKeys];
    NSLog(@"All keys are: %@", allKeys);
    switch (level) {
        case 1:
            levelData = [self.payload valueForKey:allKeys[0]];
            break;
        
        case 2:
            levelData = [self.payload valueForKey:allKeys[1]];
            break;
        default:
            break;
    }
    return levelData;
}*/


//TODO: Fix/Delete
-(NSArray *)returnDataForKeyChildren {
    //NSArray *childrenData = [[NSArray alloc] init];
    //childrenData = [self.payload valueForKey:@"data"];
    
    return 0;
}

-(NSArray *)titlesForURL:(NSURL *)theURL {
    NSArray *titles = [[NSArray alloc] init];
    NSDictionary *childrenData = [self retrieveDataFromURL:theURL];
    titles = [[childrenData valueForKey:@"data"] valueForKey:@"title"];
    
    return titles;
}

@end
