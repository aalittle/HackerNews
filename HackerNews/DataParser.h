//
//  DataParser.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataParser : NSObject {
    
}

//Parse the response data into an array of Article objects.
+(NSMutableArray *)extractArticlesFrom:(NSMutableData *)responseData;

@end
