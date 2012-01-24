//
//  RootViewController.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <iAd/iAd.h>
#import <UIKit/UIKit.h>
#import "PRPConnection.h"
#import "PRPWebViewController.h"
#import "ConfigViewControllerDelegate.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "EasyTracker.h"

@interface RootViewController : TrackedUIViewController <UITableViewDelegate, UITableViewDataSource, PRPWebViewControllerDelegate, ConfigViewControllerDelegate, MBProgressHUDDelegate, EGORefreshTableHeaderDelegate, ADBannerViewDelegate> {
    
    UITableView *myTableView;
    UIView *footerView;
    UIButton *more;
    
    PRPConnection *download;
    NSMutableArray *articles;    
    MBProgressHUD *progressView;
    
    BOOL _reloading;
    EGORefreshTableHeaderView *refreshHeaderView;
    
    ADBannerView *bannerView;
}

@property (nonatomic, retain) PRPConnection *download;
@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) MBProgressHUD *progressView;
@property (nonatomic, retain) IBOutlet UIButton *more;

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) BOOL _reloading;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;


@end
