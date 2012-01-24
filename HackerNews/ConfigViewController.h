//
//  ConfigViewController.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigViewControllerDelegate.h"
#import "EasyTracker.h"

@interface ConfigViewController : TrackedUIViewController {
   
    UISlider *freshness;
    UISlider *points;
    UISlider *comments;
    UIBarButtonItem *resetSliders;
    
    id<ConfigViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UISlider *freshness;
@property (nonatomic, retain) IBOutlet UISlider *points;
@property (nonatomic, retain) IBOutlet UISlider *comments;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *resetSliders;
@property (nonatomic, assign) id<ConfigViewControllerDelegate> delegate;

@end
