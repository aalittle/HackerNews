//
//  InfoViewController.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PRPWebViewControllerDelegate.h"
@interface InfoViewController : UIViewController <MFMailComposeViewControllerDelegate, PRPWebViewControllerDelegate> {
 
    UIButton *backButton;
    
    UIButton *email;
    UIButton *follow;
    UIButton *credits;
    UIView *creditsView;

}

@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *email;
@property (nonatomic, retain) IBOutlet UIButton *follow;
@property (nonatomic, retain) IBOutlet UIButton *credits;
@property (nonatomic, retain) IBOutlet UIView *creditsView;


@end
