/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PPRWebViewController.m
//
//  Created by Matt Drance on 6/30/10.
//  Copyright 2010 Bookhouse. All rights reserved.
//

#import <Twitter/Twitter.h>
#import "PRPWebViewController.h"
#import "TestFlight.h"

const float PRPWebViewControllerFadeDuration = 0.5;

@interface PRPWebViewController ()

- (void)fadeWebViewIn;
- (void)resetBackgroundColor;
- (void)updateForwardBackButtonStatus;
- (void)launchSafari;
- (void)emailLink;
- (void)tweetLink;

@end

@implementation PRPWebViewController

@synthesize url;
@synthesize articleID;

@synthesize backgroundColor;
@synthesize webView;
@synthesize activityIndicator;

@synthesize showsDoneButton;

@synthesize delegate;
@synthesize back;
@synthesize forward;
@synthesize refresh;
@synthesize action;
@synthesize comments;
@synthesize toolbar;

- (void)dealloc {
    [url release], url = nil;
    [articleID release], articleID = nil;
    [backgroundColor release], backgroundColor = nil;
    [webView stopLoading], webView.delegate = nil, [webView release], webView = nil;
    [activityIndicator release], activityIndicator = nil;
    [back release], back = nil;
    [forward release], forward = nil;
    [refresh release], refresh = nil;
    [back release], back = nil;
    [action release], action = nil;
    [comments release], comments = nil;
    [toolbar release], toolbar = nil;
    
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.webView = nil;
    self.activityIndicator = nil;
    self.back = nil;
    self.forward = nil;
    self.action = nil;
    self.refresh = nil;
    self.comments = nil;
    self.toolbar = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewAutoresizing resizeAllMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    webView.autoresizingMask = resizeAllMask;
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;						
    CGRect aiFrame = self.activityIndicator.frame;
    CGFloat originX = (self.view.bounds.size.width - aiFrame.size.width) / 2;
    CGFloat originY = (self.view.bounds.size.height - aiFrame.size.height) / 2;
    aiFrame.origin.x = floorl(originX);
    aiFrame.origin.y = floorl(originY);
    self.activityIndicator.frame = aiFrame;
    [self.view addSubview:activityIndicator];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:font, UITextAttributeFont, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attr];
    [attr release];
    
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:4.0 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:2.0 forBarMetrics:UIBarMetricsLandscapePhone];
    
    //If the article id is not set, then don't display the comments button
    if (!articleID) {
        self.comments.width = 0.0;
        
        NSMutableArray *reducedToolbar = [NSMutableArray arrayWithArray:[toolbar items]];
        [reducedToolbar removeObjectIdenticalTo:self.comments];
        
        [toolbar setItems:(NSArray *)reducedToolbar];
    }
    
    [self resetBackgroundColor];
    [self reload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldRotate = YES;
    
    if ([self.delegate respondsToSelector:@selector(webController:shouldAutorotateToInterfaceOrientation:)]) {
        shouldRotate = [self.delegate webController:self shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    
    return shouldRotate;
}

#pragma mark -
#pragma mark Actions

- (void)doneButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)fadeWebViewIn {
    [UIView animateWithDuration:PRPWebViewControllerFadeDuration
                     animations:^ {
                         self.webView.alpha = 1.0;                         
                     }];
}

- (void)reload {
    if (self.url) {
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];        
        [self.webView loadRequest:theRequest];
        self.webView.alpha = 0.0;
        [self.activityIndicator startAnimating];        
    }
}

#pragma mark -
#pragma mark Accessor overrides

- (void)setShowsDoneButton:(BOOL)shows {
    if (showsDoneButton != shows) {
        showsDoneButton = shows;
        if (showsDoneButton) {
            UIBarButtonItem *done = [[UIBarButtonItem alloc] 
                initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                     target:self
                                     action:@selector(doneButtonTapped:)];
            self.navigationItem.rightBarButtonItem = done;
            [done release];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void)setBackgroundColor:(UIColor *)color {
    if (backgroundColor != color) {
        [backgroundColor release];
        backgroundColor = [color retain];
        [self resetBackgroundColor];
    }
}

- (void)resetBackgroundColor {
    if ([self isViewLoaded]) {
        UIColor *bgColor = self.backgroundColor;
        if (bgColor == nil) {
            bgColor = [UIColor whiteColor];
        }
        self.view.backgroundColor = bgColor;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    
    [self.activityIndicator stopAnimating];
    [self fadeWebViewIn];
    if (self.title == nil) {
        NSString *docTitle = [self.webView 
            stringByEvaluatingJavaScriptFromString:@"document.title;"];
        if ([docTitle length] > 0) {
            self.navigationItem.title = docTitle;
        }
    }
    SEL sel_didFinishLoading = @selector(webControllerDidFinishLoading:);
    if ([self.delegate respondsToSelector:sel_didFinishLoading]) {
        [self.delegate webControllerDidFinishLoading:self];
    }
    
    [self updateForwardBackButtonStatus];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    NSLog(@"webView fail: %@", error);
    [self.activityIndicator stopAnimating];
    if ([self.delegate respondsToSelector:@selector(webController:didFailLoadWithError:)]) {
        [self.delegate webController:self didFailLoadWithError:error];
    } else {
        if ([error code] != kCFURLErrorCancelled) {            
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Failed"
                                                            message:@"The web page failed to load."
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
             */
        }
    }
    
    [self updateForwardBackButtonStatus];
}

-(IBAction)onBack {
    
    [self.webView goBack];
}

-(IBAction)onForward {

    [self.webView goForward];
}

-(IBAction)onRefresh {
    
    [self reload];
}

-(IBAction)onAction {
 
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[self.url description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tweet Link",@"Open in Safari", @"Mail Link", @"Copy Link", nil];
    
    [sheet showInView:self.view];
}

-(IBAction)onComments
{
    PRPWebViewController *commentsView = [[PRPWebViewController alloc] initWithNibName:@"PRPWebViewController" bundle:nil];

    commentsView.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://news.ycombinator.com/item?id=%@", articleID]];

    
    commentsView.showsDoneButton = YES;
    commentsView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:commentsView];
    navController.navigationBar.tintColor = [UIColor colorWithRed:249.0/255.0 green:82.0/255.0 blue:0.0 alpha:1.0];
    navController.title = @"Hacker Comments";

    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
    [commentsView release];    
}

-(void)updateForwardBackButtonStatus {
    
    //update the back button
    if ([self.webView canGoBack]) {
        
        self.back.enabled = YES;
    }
    else {
        
        self.back.enabled = NO;
    }
    
    //update the forward button
    if ([self.webView canGoForward]) {
        
        self.forward.enabled = YES;
    }
    else {
        
        self.forward.enabled = NO;
    }
}

-(void)launchSafari {

    [[UIApplication sharedApplication] openURL:self.url];
}

-(void)emailLink {
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
	mailController.navigationBar.tintColor = [UIColor colorWithRed:249.0/255.0 green:82.0/255.0 blue:0.0 alpha:1.0];
    
	[mailController setSubject:@"interesting story"];
	
    NSString *emailBody = [self.url description];
	[mailController setMessageBody:emailBody isHTML:NO];
    
	[self presentModalViewController:mailController animated:YES];
    [mailController release];
}

-(void)tweetLink
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:@""];

    [tweetViewController addURL:url];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    [TestFlight passCheckpoint:@"PRPWebViewController::didReceiveMemoryWarning"];
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


#pragma UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    UIPasteboard *pasteboard;
    
    //if the Safari button, then launch Safari
    switch (buttonIndex) {
        case 0:
            [self tweetLink];
            break;
        case 1:
            [self launchSafari];
            break;
        case 2:
            [self emailLink];
            break;
        case 3:
            pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [self.url description];
            break;            
        default:
            break;
    }
}


@end