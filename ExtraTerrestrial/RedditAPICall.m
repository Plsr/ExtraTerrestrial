//
//  RedditAPICall.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 24/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "RedditAPICall.h"

@implementation RedditAPICall

/**
 *  Performs an API/Call with the given URL and returns an NSDIctionary containing the data.
 *  This method is used for most of the API Calls of the app.
 *
 *  @param url The URL of the API route
 *
 *  @return NSDictionary containing the raw data
 *
 */
-(NSDictionary *) dictionaryWithDataForURL:(NSURL *) url {
    
    NSDictionary *requestReturns = [[NSDictionary alloc] init];
    
    //Basic URLRequest
    NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] initWithURL:url];
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



/**
 *  Performs an API/Call with the given URL and returns an NSArray containing the data.
 *  This mehtod is mostly used by singlePost calls, which return an Array on the first level.
 *
 *  @param url The URL of the API route
 *
 *  @return NSArray containing the raw data
 *
 */
-(NSArray *) arrayWithDataForURL:(NSURL *) url {
    
    NSArray *requestReturns = [[NSArray alloc] init];
    
    //Basic URLRequest
    NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] initWithURL:url];
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


@end
