//
//  RedditDataFetcher.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 23/01/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SubredditDataModel.h"

//  Constant Strings
//  TODO: Clean up!
static NSString * const kDataStr = @"data";
static NSString * const kChildrenStr = @"children";
static NSString * const kBeforeString = @"before";
static NSString * const kAfterStr = @"after";



@implementation SubredditDataModel


/**
 *  Creates a SubredditDataModel object with the contents of an API-Call for an URL
 *
 *  @param theURL The URL to use for the request
 *
 *  @return SubredditDataModel Object with an NSDictionary containing the returns of the request
 *
 *  @note theURL must be of the format http://www.reddit.com/r/subreddit.json for the function to work properly
 *
 */

-(instancetype)initWithURL:(NSURL *)theURL {
    self = [super init];
    if(self) {
        RedditAPICall *apiCall = [[RedditAPICall alloc] init];
        _payload = [[apiCall dictionaryWithDataForURL:theURL] valueForKey:kDataStr];
        _before = [_payload valueForKey:kBeforeString];
        _after = [_payload valueForKey:kAfterStr];
        
    }
    return self;
}

/**
 *  Returns an Array with Dictionaries for all given keys (For 25 Children that will be
 *  Array[24] with an NSDictionary containing the demanded keys and vlaues at every position).
 *  For non-valid values (e.g. thumbnail if there istn't one), the keys and values are simply skipped.
 *  The submitted keys are the same in the returned Dicitionaries.
 *
 *  @param theKeys  Array with the needed keys
 *
 *  @return NSArray with a Dictionary containing the wanted keys at every popsition.
 *
 */
-(NSArray *)contentOfChildrenForKeys:(NSArray *)theKeys {
    NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] initWithCapacity:[theKeys count]];
    // Init an Array with a slot for every child. Usually an API-Call returns 25 children.
    NSUInteger numberOfChildren = [[self.payload valueForKey:@"children"] count];
    NSMutableArray *preparedContent = [[NSMutableArray alloc] initWithCapacity:numberOfChildren];
    
    // Enter every child
    for (NSObject *child in [self.payload valueForKey:@"children"]) {
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
        
        // Add the current dictiionary to the array, then clean it
        [preparedContent addObject:[NSDictionary dictionaryWithDictionary:dataSet]];
        [dataSet removeAllObjects];
    }
    
    return preparedContent;
}


/** 
 *  Contructs an UIImage from a given URL.
 *  This method only exists to make some code a bit shorter.
 *
 *  @param url The url from which the UIImage should be constructed.
 *
 *  @return The UIImage.
 *
 *  @note The url is not tested to valid in this function, only use URLs that are known to be valid.
 *
 */
-(UIImage *) imageFromURL: (NSURL *) url {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}


/**
 *  Checks wether the URL is malformed (= does not lead to a proper thumbnail)
 *  In addition, checks for scheme and host
 *  
 *  @param url The URL to be checked
 *
 *  @return YES if the URL is valid, NO if it was malformed
 *
 *  @see http://stackoverflow.com/a/5081447/4181679
 */
-(BOOL) thumbnailURLIsValid: (NSURL *) url {
    if(url && url.scheme && url.host) {
        return YES;
    } else {
        return NO;
    }
}

@end
