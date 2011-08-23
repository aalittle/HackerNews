//
//  ConfigViewController.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfigViewController.h"
#import "NSUserDefaults+PRPAdditions.h"

@implementation ConfigViewController

@synthesize freshness;
@synthesize points;
@synthesize comments;
@synthesize resetSliders;

@synthesize delegate;

- (void)dealloc
{
    [freshness release], freshness = nil;
    [points release], points = nil;
    [comments release], comments = nil;
    [resetSliders release], resetSliders = nil;
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.freshness = nil;
    self.points = nil;
    self.comments = nil;
    self.resetSliders = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
    self.navigationItem.title = @"Configure Search";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.points.value = defaults.prp_pointBoost; 
    self.comments.value = defaults.prp_commentBoost;
    self.freshness.value = defaults.prp_freshBoost;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)close {
    
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)reset {
    
    self.freshness.value = FRESHNESS_DEFAULT;
    self.points.value    = POINTS_DEFAULT;
    self.comments.value  = COMMENTS_DEFAULT;
}

-(void)save {
    
    if (delegate && [delegate respondsToSelector:@selector(saveWith:commentsBoost:timeBoost:)]) {

        [[NSUserDefaults standardUserDefaults] prp_setCommentBoost:self.comments.value];
        [[NSUserDefaults standardUserDefaults] prp_setPointBoost:self.points.value];
        [[NSUserDefaults standardUserDefaults] prp_setFreshBoost:self.freshness.value];
        
        [delegate saveWith:points.value commentsBoost:comments.value timeBoost:freshness.value];
    }
}

@end
