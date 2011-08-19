//
//  Article.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Article.h"


@implementation Article

@synthesize _id;
@synthesize cache_ts;
@synthesize create_ts;
@synthesize discussion;
@synthesize domain;
@synthesize id_num;
@synthesize num_comments;
@synthesize parent_id;
@synthesize parent_sigid;
@synthesize points;
@synthesize text;
@synthesize title;
@synthesize type;
@synthesize url;
@synthesize username;

- (void)dealloc {

    [_id release];
    [cache_ts release];
    [create_ts release];
    [discussion release];
    [domain release];
    [id_num release];
    [num_comments release];
    [parent_id release];
    [parent_sigid release];
    [points release];
    [text release];
    [title release];
    [type release];
    [url release];
    [username release];
}

@end
