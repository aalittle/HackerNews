//
//  RootViewController.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRPConnection.h"
#import "PRPWebViewController.h"
#import "ConfigViewControllerDelegate.h"
#import "MBProgressHUD.h"

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PRPWebViewControllerDelegate, ConfigViewControllerDelegate, MBProgressHUDDelegate> {
    
    UITableView *myTableView;
    
    UINib *complexCellNib;
    PRPConnection *download;
    NSMutableArray *articles;    
    MBProgressHUD *progressView;
}

@property (nonatomic, retain) UINib *complexCellNib;
@property (nonatomic, retain) PRPConnection *download;
@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) MBProgressHUD *progressView;

@end
