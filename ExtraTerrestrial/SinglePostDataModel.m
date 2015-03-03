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
        _apiCallReturns = [[apiCall arrayWithDataForURL:theURL]objectAtIndex:1];
    }
    
    return self;
}


/*
// TODO: Should be deprecated
-(NSDictionary *)postContentForKeys:(NSArray *)theKeys {
    NSDictionary *postData = [[[self.apiCallReturns objectAtIndex:0] objectForKey:@"data"] objectForKey:@"children"];
    // Someone at Apple already wrote the method I need, how convenient.
    return [postData dictionaryWithValuesForKeys:theKeys];
}
 */

-(NSArray *)topLevelComments {
    NSArray *keys = [[NSArray alloc] initWithObjects:@"body", @"author", @"created", @"score", @"replies", nil];
    NSDictionary *rawCommentsData = [[self.apiCallReturns  objectForKey:@"data"] objectForKey:@"children"];
    NSMutableArray *refurbishedComments = [[NSMutableArray alloc] initWithCapacity:[rawCommentsData count]];
    NSMutableDictionary *singleCommentData = [[NSMutableDictionary alloc] initWithCapacity:[keys count]];
    NSMutableArray * tempCom;
    NSString *kind;
    
    for (NSDictionary *curComment in rawCommentsData) {
        kind = [curComment objectForKey:@"kind"];
        for (NSString *key in keys) {
            
            if ([key isEqualToString:@"replies"]) {
                if ([[[curComment objectForKey:@"data"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                    BOOL hasReplies = YES;
                    [singleCommentData setObject:[NSNumber numberWithBool:hasReplies] forKey:@"hasReplies"];
                    [singleCommentData setObject:[NSNumber numberWithInt:1] forKey:@"commentLevel"];
                    
                    // TODO: Dirty quickfix
                    if (![kind isEqualToString:@"more"]) {
                        //[singleCommentData setObject:[self repliesForComment:[[curComment objectForKey:@"data"] objectForKey:key]] forKey:key];
                        tempCom = [NSMutableArray arrayWithArray:[self firstLevelCommentsForComment:[[curComment objectForKey:@"data"] objectForKey:key] withLevel:2]];
                        
                    }
                    
                } else {
                    BOOL hasReplies = NO;
                    [singleCommentData setObject:[NSNumber numberWithBool:hasReplies] forKey:@"hasreplies"];
                    [singleCommentData setObject:[NSNumber numberWithInt:1] forKey:@"commentLevel"];
                }
            } else {
                if(![kind isEqualToString:@"more"]) {
                    [singleCommentData setObject:[[curComment objectForKey:@"data"] objectForKey:key] forKey:key];
                }
            }
            
        }
        
        [refurbishedComments addObject:[NSDictionary dictionaryWithDictionary:singleCommentData]];
        [singleCommentData removeAllObjects];
        [refurbishedComments addObjectsFromArray:tempCom];
        [tempCom removeAllObjects];
    }
    

    return refurbishedComments;
}



-(NSArray *)firstLevelCommentsForComment: (NSDictionary *) parentComment withLevel: (NSInteger) level{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"body", @"author", @"created", @"score", @"replies", nil];
    NSDictionary *rawCommentsData = [[parentComment  objectForKey:@"data"] objectForKey:@"children"];
    NSMutableArray *refurbishedComments = [[NSMutableArray alloc] initWithCapacity:[rawCommentsData count]];
    NSMutableDictionary *singleCommentData = [[NSMutableDictionary alloc] initWithCapacity:[keys count]];
    NSString *kind;
    NSMutableArray * tempCom;
    
    for (NSDictionary *curComment in rawCommentsData) {
        kind = [curComment objectForKey:@"kind"];
        for (NSString *key in keys) {
            
            if ([key isEqualToString:@"replies"]) {
                if ([[[curComment objectForKey:@"data"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                    
                    BOOL hasReplies = YES;
                    [singleCommentData setObject:[NSNumber numberWithBool:hasReplies] forKey:@"hasReplies"];
                    [singleCommentData setObject:[NSNumber numberWithInt:level] forKey:@"commentLevel"];
                    
                     // TODO: Dirty quickfix
                     if (![kind isEqualToString:@"more"]) {
                         tempCom = [NSMutableArray arrayWithArray:[self firstLevelCommentsForComment:[[curComment objectForKey:@"data"] objectForKey:key] withLevel:++level]];
                     }
                    
                    
                } else {
                    BOOL hasReplies = NO;
                    [singleCommentData setObject:[NSNumber numberWithBool:hasReplies] forKey:@"hasreplies"];
                    [singleCommentData setObject:[NSNumber numberWithInt:level] forKey:@"commentLevel"];
                }
            } else {
                if(![kind isEqualToString:@"more"]) {
                    [singleCommentData setObject:[[curComment objectForKey:@"data"] objectForKey:key] forKey:key];
                }
            }
            
        }
        
        [refurbishedComments addObject:[NSDictionary dictionaryWithDictionary:singleCommentData]];
        [singleCommentData removeAllObjects];
        [refurbishedComments addObjectsFromArray:tempCom];
        [tempCom removeAllObjects];
    }
    
    return refurbishedComments;

    
}




-(NSArray *) repliesForComment: (NSDictionary *) parentCommentData {
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"body", @"author", @"created", @"score", @"replies", nil];
    NSDictionary *rawCommentsData = [[parentCommentData  objectForKey:@"data"] objectForKey:@"children"];
    NSMutableArray *refurbishedComments = [[NSMutableArray alloc] initWithCapacity:[rawCommentsData count]];
    NSMutableDictionary *singleCommentData = [[NSMutableDictionary alloc] initWithCapacity:[keys count]];
    NSString *kind;
    
    for (NSDictionary *curComment in rawCommentsData) {
        kind = [curComment objectForKey:@"kind"];
        for (NSString *key in keys) {
            
            if ([key isEqualToString:@"replies"]) {
                if ([[[curComment objectForKey:@"data"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                    
                    BOOL hasReplies = YES;
                    [singleCommentData setObject:[NSNumber numberWithBool:hasReplies] forKey:@"hasReplies"];
                    
                    /*
                    // TODO: Dirty quickfix
                    if (![kind isEqualToString:@"more"]) {
                        [singleCommentData setObject:[self repliesForComment:[[curComment objectForKey:@"data"] objectForKey:key]] forKey:key];
                    }
                     */
                    
                } else {
                    BOOL hasReplies = NO;
                    [singleCommentData setObject:[NSNumber numberWithBool:hasReplies] forKey:@"hasreplies"];
                }
            } else {
                if(![kind isEqualToString:@"more"]) {
                    [singleCommentData setObject:[[curComment objectForKey:@"data"] objectForKey:key] forKey:key];
                }
            }
            
        }
        
        [refurbishedComments addObject:[NSDictionary dictionaryWithDictionary:singleCommentData]];
        [singleCommentData removeAllObjects];
    }
    
    return refurbishedComments;
}

@end
