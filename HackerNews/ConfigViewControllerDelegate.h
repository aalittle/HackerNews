//
//  ConfigViewControllerDelegate.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ConfigViewControllerDelegate <NSObject>

-(void)saveWith:(float)pointsBoost commentsBoost:(float)cBoost timeBoost:(float)tBoost;

@end
