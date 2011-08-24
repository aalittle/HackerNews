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

#import "PRPWebViewController.h"

const float PRPWebViewControllerFadeDuration = 0.5;

@interface PRPWebViewController ()

- (void)fadeWebViewIn;
- (void)resetBackgroundColor;
- (void)updateForwardBackButtonStatus;
- (void)launchSafari;
- (void)emailLink;

@end

@implementation PRPWebViewController

@synthesize url;

@synthesize backgroundColor;
@synthesize webView;
@synthesize activityIndicator;

@synthesize showsDoneButton;

@synthesize delegate;
@synthesize back;
@synthesize forward;
@synthesize refresh;
@synthesize action;

- (void)dealloc {
    [url release], url = nil;
    
    [backgroundColor release], backgroundColor = nil;
    [webView stopLoading], webView.delegate = nil, [webView release], webView = nil;
    [activityIndicator release], activityIndicator = nil;
    [back release], back = nil;
    [forward release], forward = nil;
    [refresh release], refresh = nil;
    [back release], back = nil;
    [action release], action = nil;
    
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
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Failed"
                                                            message:@"The web page failed to load."
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
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
 
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[self.url description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", @"Mail Link", @"Copy Link", nil];
    
    [sheet showInView:self.view];
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
    
    //if the Safari button, then launch Safari
    if (buttonIndex == 0) {
        
        [self launchSafari];
    }
    //if it's the Mail Link button, then launch the mail composer
    else if (buttonIndex == 1) {
        
        [self emailLink];
    }
    else if (buttonIndex == 2) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [self.url description];
    }
    
}


@end