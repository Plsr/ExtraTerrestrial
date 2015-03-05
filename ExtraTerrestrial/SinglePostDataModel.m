//
//  SinglePostAPICall.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 12/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SinglePostDataModel.h"

@implementation SinglePostDataModel


/**
 *  Creates a SinglePostDataModel object with the contents of an API-Call for an URL
 *
 *  @param theURL The URL to use for the request
 *
 *  @return SinglePostDataModel Object with an NSDictionary containing the returns of the request
 *
 *  @note theURL must be of the format http://www.reddit.com/r/subreddit/comments/id/title.json for the function to work properly
 *
 */
-(instancetype)initWithURL:(NSURL *)theURL {
    self = [super init];
    if(self) {
        RedditAPICall *apiCall = [[RedditAPICall alloc] init];
        _apiCallReturns = [[apiCall arrayWithDataForURL:theURL]objectAtIndex:1];
    }
    
    return self;
}



/**
 *  Creates an Array with all comments for the current post.
 *
 *  @return NSArray with comments ind NSDictionaries
 */
-(NSArray *)commentsFromDataModel {
    // Basically just calls a more complex method, but for simplicitys sake, this method (which is visible to other classes)
    // takes no arguments whatsoever.
    return [NSMutableArray arrayWithArray:[self repliesForParent:self.apiCallReturns withLevel:1]];
}


/**
 *  Recursive function which constructs an NSArray with all replies as NSDictionaries for a given parent.
 *  This is only called by commentsFromDataModel where the parent is the post istelf.
 *
 *  @param parent   NSDictionary containing the parent for which the replies are wanted
 *  @param level    The level of how deep the current Array of replies is nested
 *
 *  @return         NSArray containing the replies for the parent.
 *
 *  @note           Level starts with 1, not 0.
 *
 */
-(NSArray *)repliesForParent: (NSDictionary *) parent withLevel: (NSInteger) level {
    // Setup
    NSArray *keys = [[NSArray alloc] initWithObjects:@"body", @"author", @"created", @"score", @"replies", @"created_utc", nil];
    NSDictionary *rawCommentsData = [[parent objectForKey:@"data"] objectForKey:@"children"];
    NSMutableArray *refurbishedComments = [[NSMutableArray alloc] initWithCapacity:[rawCommentsData count]];
    NSMutableDictionary *singleCommentData = [[NSMutableDictionary alloc] initWithCapacity:[keys count]];
    NSString *kind;
    NSMutableArray * tempCom;
    
    // Enter every reply
    for (NSDictionary *curComment in rawCommentsData) {
        kind = [NSString stringWithString:[curComment objectForKey:@"kind"]];
        // Get every key
        for (NSString *key in keys) {
            
            // Replies need a special treatment
            if ([key isEqualToString:@"replies"]) {
                
                // If a parent has no more replies, the value for the key is left empty by the API
                if ([[[curComment objectForKey:@"data"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                    
                    BOOL hasReplies = YES;
                    [singleCommentData setObject:[NSNumber numberWithBool:hasReplies] forKey:@"hasReplies"];
                    [singleCommentData setObject:[NSNumber numberWithInteger:level] forKey:@"commentLevel"];
                    
                    // Recursive part: If it has more replies, get an Array with them.
                    tempCom = [NSMutableArray arrayWithArray:[self repliesForParent:[[curComment objectForKey:@"data"] objectForKey:key] withLevel:++level]];
                    
                } else {
                    BOOL hasReplies = NO;
                    [singleCommentData setObject:[NSNumber numberWithBool:hasReplies] forKey:@"hasreplies"];
                    [singleCommentData setObject:[NSNumber numberWithInteger:level] forKey:@"commentLevel"];
                }
            } else {
                
                // If the kind of the given element is "t1", it's a regular comment. Else, it's an Array containing links to further comments
                if([kind isEqualToString:@"t1"]) {
                    [singleCommentData setObject:[[curComment objectForKey:@"data"] objectForKey:key] forKey:key];
                } else {
                    // TODO: Called for every key, fix
                    // TODO: Get links of the children for later expanding
                    BOOL isMoreIndicator = YES;
                    [singleCommentData setObject:[NSNumber numberWithBool:isMoreIndicator] forKey:@"isMoreIndicator"];
                }
            }
            
        }
        
        // First, add all the data for the current comment to the array and clean it
        [refurbishedComments addObject:[NSDictionary dictionaryWithDictionary:singleCommentData]];
        [singleCommentData removeAllObjects];
        
        // Then, add all the replies for the current comment to the array
        [refurbishedComments addObjectsFromArray:tempCom];
        [tempCom removeAllObjects];
    }
    
    return refurbishedComments;

    
}

@end
