/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  NSUserDefaults+PRPAdditions.m
//  SmartUserDefaults
//
//  Created by Matt Drance on 8/27/10.
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import "NSUserDefaults+PRPAdditions.h"


NSString *const PRPDefaultsKeyFresh  = @"prp_freshBoost";
NSString *const PRPDefaultsKeyPoint   = @"prp_pointBoost";
NSString *const PRPDefaultsKeyComment = @"prp_commentBoost";

@implementation NSUserDefaults (PRPAdditions)

#pragma mark -
#pragma mark Username

+ (void)prp_registerDefaults {
    
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:POINTS_DEFAULT], PRPDefaultsKeyPoint, [NSNumber numberWithFloat:FRESHNESS_DEFAULT], PRPDefaultsKeyFresh, [NSNumber numberWithFloat:COMMENTS_DEFAULT], PRPDefaultsKeyComment, nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (float)prp_freshBoost {
    return [self floatForKey:PRPDefaultsKeyFresh];
}

- (void)prp_setFreshBoost:(float)freshBoost {
    [self setFloat:freshBoost forKey:PRPDefaultsKeyFresh];
}


- (float)prp_pointBoost {
    return [self floatForKey:PRPDefaultsKeyPoint];
}

- (void)prp_setPointBoost:(float)pointBoost {
    [self setFloat:pointBoost forKey:PRPDefaultsKeyPoint];
}


- (float)prp_commentBoost {
    return [self floatForKey:PRPDefaultsKeyComment];
}

- (void)prp_setCommentBoost:(float)commentBoost {
    [self setFloat:commentBoost forKey:PRPDefaultsKeyComment];
}

@end
