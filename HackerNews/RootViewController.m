//
//  RootViewController.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ConfigViewController.h"
#import "InfoViewController.h"
#import "ArticleTableViewCell.h"
#import "DataParser.h"
#import "Article.h"
#import "DateHelper.h"

@interface RootViewController ()

-(void)displayInfoView;
-(void)displayConfigViewController;
-(void)networkErrorAlert;

@end

@implementation RootViewController

@synthesize myTableView;
@synthesize complexCellNib;
@synthesize download;
@synthesize articles;
@synthesize progressView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    self.complexCellNib = nil;
    self.download = nil;
    self.articles = nil;
    self.myTableView = nil;
    self.progressView = nil;
}

- (void)dealloc
{
    [myTableView release], myTableView = nil;
    [complexCellNib release], complexCellNib = nil;
    [download release], download = nil;
    [articles release], articles = nil;
    [progressView release], progressView = nil;

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self saveWith:0.30 commentsBoost:0.15 timeBoost:500.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for all orientations.
	return YES;
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [articles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleTableViewCell *cell = [ArticleTableViewCell cellForTableView:tableView
                                                                fromNib:self.complexCellNib];
    
    
    return cell.frame.size.height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleTableViewCell *cell = [ArticleTableViewCell cellForTableView:tableView
                                                                      fromNib:self.complexCellNib];
    // Configure the cell.
    Article *theArticle = [articles objectAtIndex:indexPath.row];
    cell.labelTitle.text = theArticle.title;
    
    //construct the subtitle
    NSMutableString *theSubtitle = [[NSMutableString alloc] init];
    if (theArticle.points != nil) {
        
        [theSubtitle appendFormat:@"%d points", [theArticle.points intValue]];
    }
    if (theArticle.username != nil) {
        
        [theSubtitle appendFormat:@" by %@", theArticle.username];
    }
    if (theArticle.domain != nil) {
        
        [theSubtitle appendFormat:@" (via %@)", theArticle.domain];
    }
    
    cell.labelSubtitle.text = theSubtitle;
    
    if ([theArticle createDate]) {

        cell.labelSinceCreated.text = [DateHelper timeSince:[theArticle createDate]];
    }
    
    [theSubtitle release];
                              
    return cell;
}

- (UINib *)complexCellNib {
    if (complexCellNib == nil) {
        self.complexCellNib = [ArticleTableViewCell nib];
    }
    return complexCellNib;    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Article *theArticle = [articles objectAtIndex:indexPath.row];
    
    PRPWebViewController *webView = [[PRPWebViewController alloc] init];
    webView.url = [NSURL URLWithString:theArticle.url];
    webView.showsDoneButton = NO;
    webView.delegate = self;
    webView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    [self.navigationController pushViewController:webView animated:YES];
    
    [webView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


-(IBAction)displayInfoView {
    
    InfoViewController *viewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:viewController animated:YES];
    
    [viewController release];
}

-(IBAction)displayConfigViewController {
    
    ConfigViewController *viewController = [[ConfigViewController alloc] initWithNibName:@"ConfigViewController" bundle:nil];
    viewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.navigationBar.tintColor = [UIColor colorWithRed:249.0/255.0 green:82.0/255.0 blue:0.0 alpha:1.0];
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
    [viewController release];
}

#pragma ConfigViewControllerDelegate methods

-(void)saveWith:(float)pointsBoost commentsBoost:(float)cBoost timeBoost:(float)tBoost {
    
    //create a progress view indicator
    if( !progressView ) {
        progressView = [[MBProgressHUD alloc] initWithView:self.view];
        progressView.detailsLabelFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    }
    // Add progressView to screen
    NSLog(@"ProgressView was added to the view");
    [self.view addSubview:progressView];
    progressView.delegate = self;    
    progressView.labelText = @"Retrieving Articles";    
    [progressView show:YES];

    
    NSURL *hackerURL = [PRPConnection hackerNewsURLWith:pointsBoost commentsBoost:cBoost timeBoost:tBoost];
    
    NSLog(@"%@", [hackerURL description]);
    PRPConnectionProgressBlock progress = ^(PRPConnection *connection) {};
    PRPConnectionCompletionBlock complete = ^(PRPConnection *connection, NSError *error) {
        if (error) {
            
            //handle the error
            [self.progressView hide:YES];
            [self networkErrorAlert];
            
        } else {
            
            //time to parse the data
            self.articles = [DataParser extractArticlesFrom:connection.downloadData];
            [self.myTableView reloadData];
            [self.progressView hide:YES];
        }
    };
    
    self.download = [PRPConnection connectionWithURL:hackerURL
                                       progressBlock:progress
                                     completionBlock:complete];
    self.download.progressThreshold = 5;
    [self.download start]; 
    
    [self dismissModalViewControllerAnimated:YES];
}


-(void)networkErrorAlert {
    
    UIAlertView *networkIssue = [[UIAlertView alloc] initWithTitle:@"Network Issue" message:@"Sorry, we had trouble retrieving the articles.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [networkIssue show];
    
}

#pragma mark MBProgressHUD delegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    NSLog(@"ProgressView was hidden from view.");
}

@end
