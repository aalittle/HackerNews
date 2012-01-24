/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PPRWebViewController.h
//
//  Created by Matt Drance on 6/30/10.
//  Copyright 2010 Bookhouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PRPWebViewControllerDelegate.h"
#import "EasyTracker.h"

@interface PRPWebViewController : TrackedUIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *articleID;

@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forward;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refresh;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *action;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *comments;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, assign) BOOL showsDoneButton;

@property (nonatomic, assign) id <PRPWebViewControllerDelegate> delegate;

- (void)reload;

-(IBAction)onBack;
-(IBAction)onForward;
-(IBAction)onRefresh;
-(IBAction)onAction;
-(IBAction)onComments;

@end