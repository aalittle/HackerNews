//
//  RootViewController.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ConfigViewController.h"
#import "ArticleTableViewCell.h"
#import "DataParser.h"
#import "Article.h"
#import "DateHelper.h"

@interface RootViewController ()

-(void)displayInfoView;
-(void)closeInfoView;
-(void)displayConfigViewController;

@end

@implementation RootViewController

@synthesize complexCellNib;
@synthesize download;
@synthesize articles;
@synthesize infoView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    self.complexCellNib = nil;
    self.download = nil;
    self.articles = nil;
    self.infoView = nil;
}

- (void)dealloc
{
    [super dealloc];
    [complexCellNib release], complexCellNib = nil;
    [download release], download = nil;
    [articles release], articles = nil;
    [infoView release], infoView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //get the info view prepared for display
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"InfoView"
                                                      owner:self
                                                    options:nil];
    
    self.infoView = [nibViews objectAtIndex:0];
    
    //set the left button to display the info screen
    [self.navigationItem.leftBarButtonItem setAction:@selector(displayInfoView)];
    [self.navigationItem.leftBarButtonItem setTarget:self];
 
    //set the right button to display the config screen
    [self.navigationItem.rightBarButtonItem setAction:@selector(displayConfigViewController)];
    [self.navigationItem.rightBarButtonItem setTarget:self];

    [self saveWith:0.30 commentsBoost:0.15 timeBoost:500.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    cell.labelSubtitle.text = [NSString stringWithFormat:@"%d points by %@ (via %@)", [theArticle.points intValue], theArticle.username, theArticle.domain]; 
    cell.labelSinceCreated.text = [DateHelper timeSince:[theArticle createDate]];
                              
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
    [self closeInfoView];
    
    Article *theArticle = [articles objectAtIndex:indexPath.row];
    
    PRPWebViewController *webView = [[PRPWebViewController alloc] init];
    webView.url = [NSURL URLWithString:theArticle.url];
    webView.showsDoneButton = NO;
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:webView animated:YES];
    
    [webView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


-(void)displayInfoView {
    
    //set the action to close this view
    [self.navigationItem.leftBarButtonItem setAction:@selector(closeInfoView)];
    [self.view addSubview:infoView];

}

-(void)closeInfoView {
    
    [self.navigationItem.leftBarButtonItem setAction:@selector(displayInfoView)];
    [infoView removeFromSuperview];
}

-(void)displayConfigViewController {
    
    [self closeInfoView];
    
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
    
    NSURL *hackerURL = [PRPConnection hackerNewsURLWith:pointsBoost commentsBoost:cBoost timeBoost:tBoost];
    
    NSLog(@"%@", [hackerURL description]);
    PRPConnectionProgressBlock progress = ^(PRPConnection *connection) {};
    PRPConnectionCompletionBlock complete = ^(PRPConnection *connection, NSError *error) {
        if (error) {
            
            //handle the error
            
        } else {
            
            //time to parse the data
            self.articles = [DataParser extractArticlesFrom:connection.downloadData];
            [self.tableView reloadData];
        }
    };
    
    self.download = [PRPConnection connectionWithURL:hackerURL
                                       progressBlock:progress
                                     completionBlock:complete];
    self.download.progressThreshold = 5;
    [self.download start]; 
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
