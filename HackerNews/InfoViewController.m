//
//  InfoViewController.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InfoViewController.h"


@implementation InfoViewController

@synthesize backButton;
@synthesize follow;
@synthesize email;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [backButton release], backButton = nil;
    [follow release], follow = nil;
    [email release], email = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.email.layer.borderColor = [UIColor grayColor].CGColor;
    self.email.layer.borderWidth = 1.0f;

    self.follow.layer.borderColor = [UIColor grayColor].CGColor;
    self.follow.layer.borderWidth = 1.0f;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.backButton = nil;
    self.follow = nil;
    self.email = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)onBack {
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
