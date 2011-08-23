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

    [super dealloc];
}

-(NSDate *)createDate {
    
    NSDate *theDate = nil;
    
    if (self.create_ts) {
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        dateFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dateFormat.calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        dateFormat.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
        theDate = [dateFormat dateFromString:self.create_ts];
        
        NSLog(@"date %@", [theDate description]);
        [dateFormat release];
    }
    return theDate;
}

@end
