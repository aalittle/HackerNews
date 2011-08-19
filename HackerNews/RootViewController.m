//
//  RootViewController.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ArticleTableViewCell.h"
#import "DataParser.h"
#import "Article.h"
#import "DateHelper.h"

@implementation RootViewController

@synthesize complexCellNib;
@synthesize download;
@synthesize articles;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSURL *hackerURL = [PRPConnection hackerNewsURLWith:0.30 commentsBoost:0.15 timeBoost:500.0];
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    self.complexCellNib = nil;
}

- (void)dealloc
{
    [super dealloc];
    [complexCellNib release], complexCellNib = nil;
    
}

@end
