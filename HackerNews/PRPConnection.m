/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PRPConnection.m
//  SimpleDownload
//
//  Created by Matt Drance on 3/1/10.
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import "PRPConnection.h"

@interface PRPConnection ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, copy)   NSURL *url;
@property (nonatomic, copy) NSURLRequest *urlRequest;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, assign) NSInteger contentLength;

@property (nonatomic, assign) float previousMilestone;

@property (nonatomic, copy) PRPConnectionProgressBlock progressBlock;
@property (nonatomic, copy) PRPConnectionCompletionBlock completionBlock;

@end


@implementation PRPConnection

@synthesize url;
@synthesize urlRequest;
@synthesize connection;
@synthesize contentLength;
@synthesize downloadData;
@synthesize progressThreshold;
@synthesize previousMilestone;

@synthesize progressBlock;
@synthesize completionBlock;

- (void)dealloc {
    [url release], url = nil;
    [urlRequest release], urlRequest = nil;
    [connection cancel], [connection release], connection = nil;
    [downloadData release], downloadData = nil;
    [progressBlock release], progressBlock = nil;
    [completionBlock release], completionBlock = nil;
    
    [super dealloc];
}

+ (NSURL *)hackerNewsURLWith:(float)pointsBoost commentsBoost:(float)cBoost timeBoost:(float)tBoost {
    
    NSURL *theURL = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://api.thriftdb.com/api.hnsearch.com/items/_search?q=submission&limit=30&weights[title]=0.0&weights[text]=0.0&weights[domain]=0.0&weights[username]=0.0&weights[type]=2.0&boosts[fields][points]=%f&boosts[fields][num_comments]=%f&boosts[functions][pow(2,div(div(ms(create_ts,NOW),3600000),72))]=%f&pretty_print=true", pointsBoost, cBoost, tBoost]] autorelease];
    
    return theURL;
}


+ (id)connectionWithRequest:(NSURLRequest *)request
              progressBlock:(PRPConnectionProgressBlock)progress
            completionBlock:(PRPConnectionCompletionBlock)completion {
    return [[[self alloc] initWithRequest:request
                            progressBlock:progress
                          completionBlock:completion]
            autorelease];
}

+ (id)connectionWithURL:(NSURL *)downloadURL
          progressBlock:(PRPConnectionProgressBlock)progress
        completionBlock:(PRPConnectionCompletionBlock)completion {
    return [[[self alloc] initWithURL:downloadURL
                        progressBlock:progress
                      completionBlock:completion] 
            autorelease];
}

- (id)initWithURL:(NSURL *)requestURL
    progressBlock:(PRPConnectionProgressBlock)progress
  completionBlock:(PRPConnectionCompletionBlock)completion {
    return [self initWithRequest:[NSURLRequest requestWithURL:requestURL]
                   progressBlock:progress
                 completionBlock:completion];
}

- (id)initWithRequest:(NSURLRequest *)request
        progressBlock:(PRPConnectionProgressBlock)progress 
      completionBlock:(PRPConnectionCompletionBlock)completion {
    if ((self = [super init])) {
        urlRequest = [request copy];
        progressBlock = [progress copy];
        completionBlock = [completion copy];
        url = [[request URL] copy];
        progressThreshold = 1.0;
    }
    return self;
}

#pragma mark -
#pragma mark 

- (void)start {
    self.connection = [NSURLConnection connectionWithRequest:self.urlRequest delegate:self];
}

- (void)stop {
    [self.connection cancel];
    self.connection = nil;
    self.downloadData = nil;
    self.contentLength = 0;
    self.progressBlock = nil;
    self.completionBlock = nil;
}

- (float)percentComplete {
    if (self.contentLength <= 0) return 0;
    return (([self.downloadData length] * 1.0f) / self.contentLength) * 100;
}

#pragma mark 
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] == 200) {
            NSDictionary *header = [httpResponse allHeaderFields];
            NSString *contentLen = [header valueForKey:@"Content-Length"];
            NSInteger length = self.contentLength = [contentLen integerValue];
            self.downloadData = [NSMutableData dataWithCapacity:length];
        }
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];
    float pctComplete = floor([self percentComplete]);
    if ((pctComplete - self.previousMilestone) >= self.progressThreshold) {
        self.previousMilestone = pctComplete;
        if (self.progressBlock) self.progressBlock(self);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed");
    if (self.completionBlock) self.completionBlock(self, error);
    self.connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.completionBlock) self.completionBlock(self, nil);
    self.connection = nil;
}

@end