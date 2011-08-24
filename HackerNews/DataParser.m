//
//  DataParser.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataParser.h"
#import "SBJson.h"
#import "Article.h"

@implementation DataParser

+(NSMutableArray *)extractArticlesFrom:(NSMutableData *)responseData {
    
    // Create new SBJSON parser object
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", json_string);
    // parse the JSON response into an object
    // Here we're using NSArray since we're parsing an array of JSON status objects
    NSDictionary *elements = [parser objectWithString:json_string error:nil];

    [json_string release];
    [parser release];
    
    NSArray *articles = [elements objectForKey:@"results"];

    NSMutableArray  *articleObjects = [[[NSMutableArray alloc] init] autorelease];
    
    // Each element in statuses is a single status
    // represented as a NSDictionary
    for (NSDictionary *articleData in articles)
    {
        NSDictionary *articleDetail = [articleData objectForKey:@"item"];
        
        Article *articleObject = [[[Article alloc] init] autorelease];
        
        articleObject._id = ( [articleDetail objectForKey:@"_id"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"_id"];
        articleObject.cache_ts = ( [articleDetail objectForKey:@"cache_ts"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"cache_ts"];
        articleObject.create_ts = ( [articleDetail objectForKey:@"create_ts"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"create_ts"];
        articleObject.discussion = ( [articleDetail objectForKey:@"discussion"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"discussion"];
        articleObject.domain = ( [articleDetail objectForKey:@"domain"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"domain"];
        articleObject.id_num = ( [articleDetail objectForKey:@"id"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"id"];
        articleObject.num_comments = ( [articleDetail objectForKey:@"num_comments"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"num_comments"];
        articleObject.parent_id = ( [articleDetail objectForKey:@"parent_id"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"parent_id"];
        articleObject.parent_sigid = ( [articleDetail objectForKey:@"parent_sigid"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"parent_sigid"];
        articleObject.points = ( [articleDetail objectForKey:@"points"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"points"];
        articleObject.text = ( [articleDetail objectForKey:@"text"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"text"];
        articleObject.title = ( [articleDetail objectForKey:@"title"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"title"];
        articleObject.type = ( [articleDetail objectForKey:@"type"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"type"];
        
        if ([articleDetail objectForKey:@"url"] == [NSNull null]) {
            NSLog(@"****************************");
        }
        articleObject.url = ([articleDetail objectForKey:@"url"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"url"];
        NSLog(@"%@", [articleDetail objectForKey:@"url"]);
        
        articleObject.username = ( [articleDetail objectForKey:@"username"] == [NSNull null] ) ? nil : [articleDetail objectForKey:@"username"];
        
        //add the new article object to the array, but only if the article has a title
        if ([articleObject.title length] > 0 ) {

            [articleObjects addObject:articleObject];
        }
    }
    
    return articleObjects;
}


@end
