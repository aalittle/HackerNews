/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  NSUserDefaults+PRPAdditions.h
//  SmartUserDefaults
//
//  Created by Matt Drance on 8/27/10.
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FRESHNESS_DEFAULT   1200.00
#define POINTS_DEFAULT       0.3247      
#define COMMENTS_DEFAULT     0.1293


@interface NSUserDefaults (PRPAdditions) 


@property (assign, getter=prp_freshBoost, 
           setter=prp_setFreshBoost:) float prp_freshBoost;
@property (assign, getter=prp_pointBoost, 
           setter=prp_setPointBoost:) float prp_pointBoost;
@property (assign, getter=prp_commentBoost, 
           setter=prp_setCommentBoost:) float prp_commentBoost;

+(void)prp_registerDefaults;

@end
