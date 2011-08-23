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
#import "EGORefreshTableHeaderView.h"

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PRPWebViewControllerDelegate, ConfigViewControllerDelegate, MBProgressHUDDelegate, EGORefreshTableHeaderDelegate> {
    
    UITableView *myTableView;
    
    UINib *complexCellNib;
    PRPConnection *download;
    NSMutableArray *articles;    
    MBProgressHUD *progressView;
    
    BOOL _reloading;
    EGORefreshTableHeaderView *refreshHeaderView;
}

@property (nonatomic, retain) UINib *complexCellNib;
@property (nonatomic, retain) PRPConnection *download;
@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) MBProgressHUD *progressView;

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) BOOL _reloading;

@end
