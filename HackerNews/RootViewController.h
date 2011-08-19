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
#import "InfoView.h"

@interface RootViewController : UITableViewController <PRPWebViewControllerDelegate> {
    
    UINib *complexCellNib;
    PRPConnection *download;
    NSMutableArray *articles;    
    InfoView *infoView;
}

@property (nonatomic, retain) UINib *complexCellNib;
@property (nonatomic, retain) PRPConnection *download;
@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, retain) InfoView *infoView;

@end
