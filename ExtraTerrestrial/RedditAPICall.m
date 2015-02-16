//
//  RedditDataFetcher.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 23/01/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "RedditAPICall.h"

//  Constant Strings
//  TODO: Clean up!
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
 *  Returns an Array with Dictionaries for all given keys (For 25 Children that will be
 *  Array[24] with an NSDictionary of the demanded keys and vlaues at every position).
 *  For non-valid values (e.g. thumbnail if there istn't one), the keys and values are simply skipped.
 *  The submitted keys are the same in the returned Dicitionaries.
 */
-(NSArray *)contentOfChildrenForKeys:(NSArray *)theKeys {
    NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] initWithCapacity:[theKeys count]];
    // Init an Array with a slot for every child. Usually an API-Call returns 25 children.
    NSUInteger numberOfChildren = [[self.apiCallReturns valueForKey:@"children"] count];
    NSMutableArray *preparedContent = [[NSMutableArray alloc] initWithCapacity:numberOfChildren];
    
    // Enter every child
    for (NSObject *child in [self.apiCallReturns valueForKey:@"children"]) {
        // Check every demanded key
        for (NSString *key in theKeys) {
            // A child has a thumbnail if the thumbnail-field contains a valid URL.
            // If it has a thumbnail, the URL is converted to an UIImage, so that this does not need to be done while building the Table.
            // If it does not have a thumbnail, the "thumbnail"-key will not be set.
            if([key isEqualToString:@"thumbnail"]) {
                NSURL *candidateURL = [NSURL URLWithString:[[child valueForKey:@"data"] valueForKey:key]];
                if([self thumbnailURLIsValid:candidateURL]){
                    [dataSet setObject:[self imageFromURL:candidateURL] forKey:key];
                }
            } else {
                // For every other key, the given value and key can simply be copied.
                [dataSet setObject:[[child valueForKey:@"data"] valueForKey:key] forKey:key];
            }
        }
        
        [preparedContent addObject:[NSDictionary dictionaryWithDictionary:dataSet]];
        [dataSet removeAllObjects];
    }
    
    return preparedContent;
}

/*
 *  Helper method to make shorter method calls possible.
 */
-(UIImage *) imageFromURL: (NSURL *) url {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}


/*
 *  If the URL was malformed it will be nil.
 *  In addition, check for scheme and host (see http://stackoverflow.com/a/5081447/4181679 )
 */
-(BOOL) thumbnailURLIsValid: (NSURL *) url {
    if(url && url.scheme && url.host) {
        return YES;
    } else {
        return NO;
    }
}

@end
