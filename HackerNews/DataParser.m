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
    
    NSArray *articles = [elements objectForKey:@"results"];

    NSMutableArray  *articleObjects = [[[NSMutableArray alloc] init] autorelease];
    
    // Each element in statuses is a single status
    // represented as a NSDictionary
    for (NSDictionary *articleData in articles)
    {
        NSDictionary *articleDetail = [articleData objectForKey:@"item"];
        
        Article *articleObject = [[[Article alloc] init] autorelease];
        
        articleObject._id = [articleDetail objectForKey:@"_id"];
        articleObject.cache_ts = [articleDetail objectForKey:@"cache_ts"];
        articleObject.create_ts = [articleDetail objectForKey:@"create_ts"];
        articleObject.discussion = [articleDetail objectForKey:@"discussion"];
        articleObject.domain = [articleDetail objectForKey:@"domain"];
        articleObject.id_num = [articleDetail objectForKey:@"id"];
        articleObject.num_comments = [articleDetail objectForKey:@"num_comments"];
        articleObject.parent_id = [articleDetail objectForKey:@"parent_id"];
        articleObject.parent_sigid = [articleDetail objectForKey:@"parent_sigid"];
        articleObject.points = [articleDetail objectForKey:@"points"];
        articleObject.text = [articleDetail objectForKey:@"text"];
        articleObject.title = [articleDetail objectForKey:@"title"];
        articleObject.type = [articleDetail objectForKey:@"type"];
        articleObject.url = [articleDetail objectForKey:@"url"];
        articleObject.username = [articleDetail objectForKey:@"username"];
        
        //add the new article object to the array
        [articleObjects addObject:articleObject];
    }
    
    return articleObjects;
}


@end
