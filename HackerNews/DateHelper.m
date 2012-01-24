//
//  DateHelper.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateHelper.h"


@implementation DateHelper

+(NSString *)timeSince:(NSDate *)aDate {
    
    NSString *theTimeSince = nil;
    NSDate *now = [NSDate date];
    
    NSInteger secondsSince = [now timeIntervalSinceDate:aDate];
    
    //if under a minute has passed
    if ( secondsSince < 60 ) {
        
        theTimeSince = @"fresh";
    }
    //if under an hour has passed
    else if( secondsSince < 3600 ) {
        
        theTimeSince = [NSString stringWithFormat:@"%d m", secondsSince / 60];
    }
    //if under a day has passed
    else if( secondsSince < 86400 ) {
        
        theTimeSince = [NSString stringWithFormat:@"%d h", secondsSince / 3600];
    }
    //display the number of days
    else {
        
        theTimeSince = [NSString stringWithFormat:@"%d d", secondsSince / 86400];
    }
    
    return theTimeSince;
}


@end
