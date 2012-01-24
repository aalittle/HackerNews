//
//  InfoViewController.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InfoViewController.h"
#import "PRPWebViewController.h"

@interface InfoViewController (PrivateMethods)

-(void)launchWebView:(NSString *)urlAsString;

@end

@implementation InfoViewController

@synthesize backButton;
@synthesize follow;
@synthesize email;
@synthesize credits;
@synthesize creditsView;

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
    [credits release], credits = nil;
    [creditsView release], creditsView = nil;
    
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

    self.credits.layer.borderColor = [UIColor grayColor].CGColor;
    self.credits.layer.borderWidth = 1.0f;

    self.creditsView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.creditsView.layer.borderWidth = 2.0f;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.backButton = nil;
    self.follow = nil;
    self.email = nil;
    self.credits = nil;
    self.creditsView = nil;
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
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)onCredits {
    
    CGRect newFrame;
    
    //only move the credits screen into view, if it is off the view
    if (self.creditsView.frame.origin.y > self.creditsView.frame.size.height) {
     
        newFrame = CGRectMake(self.creditsView.frame.origin.x, self.creditsView.frame.origin.y-self.creditsView.frame.size.height, self.creditsView.frame.size.width, self.creditsView.frame.size.height);
    }
    else {
            
        newFrame = CGRectMake(self.creditsView.frame.origin.x, self.creditsView.frame.origin.y+self.creditsView.frame.size.height, self.creditsView.frame.size.width, self.creditsView.frame.size.height);            
    }
    
    [UIView animateWithDuration:0.5
                            delay:0 
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.creditsView.frame = newFrame;
                         }
                         completion:^( BOOL finished ) {
                         }];
}


#pragma Credit View button handling

-(IBAction)onDismiss {
    
    CGRect newFrame;
    
    //only move the credits screen into view, if it is off the view
    if (self.creditsView.frame.origin.y < self.creditsView.frame.size.height) {
        
        newFrame = CGRectMake(self.creditsView.frame.origin.x, self.creditsView.frame.origin.y+self.creditsView.frame.size.height, self.creditsView.frame.size.width, self.creditsView.frame.size.height);
        
        [UIView animateWithDuration:0.5
                              delay:0 
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.creditsView.frame = newFrame;
                         }
                         completion:^( BOOL finished ) {
                         }];
    }

}


-(IBAction)onCell1 {
    
    [self launchWebView:@"http://pragprog.com/book/cdirec/ios-recipes"];
}

-(IBAction)onCell2 {

    [self launchWebView:@"http://twitter.com/#!/lorenb"];
}

-(IBAction)onCell3 {
  
    [self launchWebView:@"http://glyphish.com/"];
}

-(IBAction)onCell4 {
  
    [self launchWebView:@"https://github.com/jdg/MBProgressHUD"];
}

-(IBAction)onCell5 {
   
    [self launchWebView:@"https://github.com/stig/json-framework"];
}

-(IBAction)onCell6 {
   
    [self launchWebView:@"https://github.com/enormego/EGOTableViewPullRefresh"];
}

-(void)launchWebView:(NSString *)urlAsString {
 
    PRPWebViewController *webView = [[PRPWebViewController alloc] initWithNibName:@"PRPWebViewController" bundle:nil];
    webView.url = [NSURL URLWithString:urlAsString];
    webView.showsDoneButton = YES;
    webView.delegate = self;
    webView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    navController.navigationBar.tintColor = [UIColor colorWithRed:249.0/255.0 green:82.0/255.0 blue:0.0 alpha:1.0];
    
    [self presentModalViewController:navController animated:YES];

    [navController release];
    [webView release];
}

@end

