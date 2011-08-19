//
//  Article.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Article : NSObject {
    
    NSString *_id;
    NSString *cache_ts;
    NSString *create_ts;
    NSString *discussion;
    NSString *domain;
    NSNumber *id_num;
    NSNumber *num_comments;
    NSNumber *parent_id;
    NSNumber *parent_sigid;
    NSNumber *points;
    NSString *text;
    NSString *title;
    NSString *type;
    NSString *url;
    NSString *username;
    
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *cache_ts;
@property (nonatomic, retain) NSString *create_ts;
@property (nonatomic, retain) NSString *discussion;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSNumber *id_num;
@property (nonatomic, retain) NSNumber *num_comments;
@property (nonatomic, retain) NSNumber *parent_id;
@property (nonatomic, retain) NSNumber *parent_sigid;
@property (nonatomic, retain) NSNumber *points;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *username;

-(NSDate *)createDate;

@end
