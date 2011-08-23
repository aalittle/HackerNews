//
//  InfoViewController.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController {
 
    UIButton *backButton;
    
    UIButton *email;
    UIButton *follow;

}

@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *email;
@property (nonatomic, retain) IBOutlet UIButton *follow;


@end
