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
@synthesize gradientBar;

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
    [gradientBar release], gradientBar = nil;
    
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
    
    self.gradientBar.layer.borderColor = [UIColor grayColor].CGColor;
    self.gradientBar.layer.borderWidth = 1.0f;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.backButton = nil;
    self.follow = nil;
    self.email = nil;
    self.gradientBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)onBack {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)onEmail {
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
	mailController.navigationBar.tintColor = [UIColor colorWithRed:249.0/255.0 green:82.0/255.0 blue:0.0 alpha:1.0];
    
	[mailController setSubject:@"a quick message"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"aalittle@gmail.com"]; 
    [mailController setToRecipients:toRecipients];
		
	[self presentModalViewController:mailController animated:YES];
    [mailController release];
}

#pragma MFMailComposer delegate

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
		case MFMailComposeResultSaved:
		case MFMailComposeResultSent:
		case MFMailComposeResultFailed:
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}



-(IBAction)onFollow {
    
    BOOL twitter = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=aalittle"]];
    if (twitter) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=aalittle"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/aalittle"]];
    }
}


@end

