//
//  RedditDataFetcher.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 23/01/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "RedditAPICall.h"

//  Constant Strings
static NSString * const kDataStr = @"data";
static NSString * const kChildrenStr = @"children";
static NSString * const kBeforeString = @"before";
static NSString * const kAfterStr = @"after";



@implementation RedditAPICall

-(instancetype)initWithURL:(NSURL *)theURL {
    self = [super init];
    if(self) {
        _apiCallReturns = [[self retrieveDataFromURL:theURL] valueForKey:kDataStr];
        _before = [_apiCallReturns valueForKey:kBeforeString];
        _after = [_apiCallReturns valueForKey:kAfterStr];
        
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
           //TODO: handle possible errors and foo
        }
    }

    return requestReturns;
}


/*
 ARE THOSE NEEDED?
 */

//  Return Array with data for given Key
//  TODO: Check if key is valid
-(NSArray *)dataForKeyArray:(NSString *)theKey {
    NSArray *data = [self.apiCallReturns valueForKey:theKey];
    return data;
}


//  Return Dictionary with data for given key
//  TODO: Check if key is valid
-(NSDictionary *)dataForKeyDictionary:(NSString *)theKey {
    NSDictionary *data = [self.apiCallReturns valueForKey:theKey];
    return data;
}

/*
 *  Returns an Dictionary with Arrays for all given keys. 
 *  Note that it returns an Array with the values of _every_ child for the given key.
 *  The given keys are copied to the Dictionary as keys.
 */
-(NSArray *)contentOfChildrenForKeys:(NSArray *)theKeys {
    NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] initWithCapacity:[theKeys count]];
    NSMutableArray *preparedContent = [[NSMutableArray alloc] initWithCapacity:[[self.apiCallReturns valueForKey:@"children"] count]];
    
    for (NSObject *child in [self.apiCallReturns valueForKey:@"children"]) {
        for (NSString *key in theKeys) {
            if([key isEqualToString:@"thumbnail"]) {
                if([self thumbnailURLHasContent:[[child valueForKey:@"data"] valueForKey:key]]){
                    [dataSet setObject:[self imageFromURL:[NSURL URLWithString:[[child valueForKey:@"data"] valueForKey:key]]] forKey:key];
                }
            } else {
                [dataSet setObject:[[child valueForKey:@"data"] valueForKey:key] forKey:key];
            }
        }
        [preparedContent addObject:[NSDictionary dictionaryWithDictionary:dataSet]];
        [dataSet removeAllObjects];
    }
    
    return preparedContent;
}

-(UIImage *) imageFromURL: (NSURL *) url {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}


-(BOOL) thumbnailURLHasContent: (NSString *) url {
    //TODO: check with regex
    if([url isEqualToString:@""] || [url isEqualToString:@"self"] || [url isEqualToString:@"default"]){
        return NO;
    } else {
        return YES;
    }
}

@end
