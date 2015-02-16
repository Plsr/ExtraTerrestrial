//
//  SinglePostAPICall.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 12/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SinglePostAPICall.h"

@implementation SinglePostAPICall

-(instancetype)initWithURL:(NSURL *)theURL {
    self = [super init];
    if(self) {
        _apiCallReturns = [self retrieveDataFromURL:theURL];
    }
    
    return self;
}

//  Perform an API Call
-(NSArray *) retrieveDataFromURL:(NSURL *)targetURL {
    
    NSArray *requestReturns = [[NSArray alloc] init];
    
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
            //TODO: handle possible errors and foo
        }
    }
    
    return requestReturns;
}

-(NSDictionary *)postContentForKeys:(NSArray *)theKeys {
    NSDictionary *postData = [[[self.apiCallReturns objectAtIndex:0] objectForKey:@"data"] objectForKey:@"children"];
    // Someone at Apple already wrote the method I need, how convenient.
    return [postData dictionaryWithValuesForKeys:theKeys];
}

@end
