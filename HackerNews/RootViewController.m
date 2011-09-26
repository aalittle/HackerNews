//
//  RootViewController.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSUserDefaults+PRPAdditions.h"
#import "RootViewController.h"
#import "ConfigViewController.h"
#import "InfoViewController.h"
#import "ArticleTableViewCell.h"
#import "DataParser.h"
#import "Article.h"
#import "DateHelper.h"
#import "TestFlight.h"

#define ROW_HEIGHT 73.0

@interface RootViewController ()

-(void)displayInfoView;
-(void)displayConfigViewController;
-(void)networkErrorAlert;
-(void)doneLoadingData;
-(void)requestNews:(NSInteger)withStartIndex pointsBoost:(float)pBoost commentsBoost:(float)cBoost timeBoost:(float)tBoost;

@end

@implementation RootViewController

@synthesize myTableView;
@synthesize download;
@synthesize articles;
@synthesize progressView;
@synthesize refreshHeaderView;
@synthesize _reloading;
@synthesize more;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.download = nil;
    self.articles = nil;
    self.myTableView = nil;
    self.progressView = nil;
    self.refreshHeaderView = nil;
    self.more = nil;
}

- (void)dealloc
{
    [myTableView release], myTableView = nil;
    [download release], download = nil;
    [articles release], articles = nil;
    [progressView release], progressView = nil;
    [refreshHeaderView release], refreshHeaderView = nil;
    [more release], more = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
		view.delegate = self;
		[self.myTableView addSubview:view];
		refreshHeaderView = view;
		[view release];
	}
	
	//  update the last update date
	[refreshHeaderView refreshLastUpdatedDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self requestNews:0 pointsBoost:defaults.prp_pointBoost commentsBoost:defaults.prp_commentBoost timeBoost:defaults.prp_freshBoost];
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
    
    return ROW_HEIGHT;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCell";
    
	ArticleTableViewCell *cell = (ArticleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.frame = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
	}
    
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
    
    [cell redisplay];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Article *theArticle = [articles objectAtIndex:indexPath.row];
    
    if ( theArticle.url == nil || [theArticle.url length] == 0) {
        
        UIAlertView *linkIssue = [[UIAlertView alloc] initWithTitle:@"Missing Link" message:@"Sorry, the link to this article is missing.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [linkIssue show];
        [linkIssue release];
    }
    else {

        PRPWebViewController *webView = [[PRPWebViewController alloc] initWithNibName:@"PRPWebViewController" bundle:nil];
        webView.url = [NSURL URLWithString:theArticle.url];
        webView.showsDoneButton = NO;
        webView.delegate = self;
        webView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:231.0/255.0 alpha:1.0];
        
        [self.navigationController pushViewController:webView animated:YES];
        
        [webView release];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    [TestFlight passCheckpoint:@"RootViewController::didReceiveMemoryWarning"];
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
    
    //get a fresh set of articles
    [self requestNews:0 pointsBoost:pointsBoost commentsBoost:cBoost timeBoost:tBoost];
    
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)onRequestMoreNews {
    
    NSInteger theStartIndex = 0;
    
    if ([articles count] > 0) {
        
        theStartIndex = [articles count];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self requestNews:theStartIndex pointsBoost:defaults.prp_pointBoost commentsBoost:defaults.prp_commentBoost timeBoost:defaults.prp_freshBoost];
}

-(void)requestNews:(NSInteger)withStartIndex pointsBoost:(float)pBoost commentsBoost:(float)cBoost timeBoost:(float)tBoost {
    
    //create a progress view indicator 
    if( !progressView ) {
        progressView = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        progressView.detailsLabelFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    }
    // Add progressView to screen
    NSLog(@"ProgressView was added to the view");
    [self.navigationController.view addSubview:progressView];
    progressView.delegate = self;    
    progressView.labelText = @"Retrieving Articles";    
    
    //if we are not already showing a "loading" message due to "pull to refresh"
    if (!_reloading) {
        
        [progressView show:YES];
    }
    
    
    NSURL *hackerURL = [PRPConnection hackerNewsURLWith:withStartIndex  pointsBoost:pBoost commentsBoost:cBoost timeBoost:tBoost];
    
    NSLog(@"%@", [hackerURL description]);
    PRPConnectionProgressBlock progress = ^(PRPConnection *connection) {};
    PRPConnectionCompletionBlock complete = ^(PRPConnection *connection, NSError *error) {
        if (error) {
            
            //handle the error
            [self doneLoadingData];
            [self.progressView hide:YES];
            [self networkErrorAlert];
            
        } else {
            
            //time to parse the data
            if (connection.startIndex == 0) {
                
                self.articles = [DataParser extractArticlesFrom:connection.downloadData];
            }
            else {
                
                //append to existing articles
                [self.articles addObjectsFromArray:(NSArray *)[DataParser extractArticlesFrom:connection.downloadData]];
            }
            
            [self.myTableView reloadData];
            [self.progressView hide:YES];
            [self doneLoadingData];
            
            //add the More button to the table footer
            self.myTableView.tableFooterView = self.more;
            self.more.hidden = NO;
        }
    };
    
    self.download = [PRPConnection connectionWithURL:hackerURL
                                       progressBlock:progress
                                     completionBlock:complete
                                        theStartIndex:withStartIndex];
    self.download.progressThreshold = 5;
    [self.download start]; 
}


-(void)networkErrorAlert {
    
    UIAlertView *networkIssue = [[UIAlertView alloc] initWithTitle:@"Network Issue" message:@"Sorry, we had trouble retrieving the articles.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [networkIssue show];
    [networkIssue release];
}

#pragma mark MBProgressHUD delegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    NSLog(@"ProgressView was hidden from view.");
}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
    _reloading = YES;
}

- (void)doneLoadingData{
	
	//  model should call this when its done loading
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];	
    _reloading = NO;
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];	
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    _reloading = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                
	[self requestNews:0 pointsBoost:defaults.prp_pointBoost commentsBoost:defaults.prp_commentBoost timeBoost:defaults.prp_freshBoost];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
