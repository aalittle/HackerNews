//
//  ArticleTableViewCell.h
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRPNibBasedTableViewCell.h"

@interface ArticleTableViewCell : UITableViewCell {
    
    UILabel *labelTitle;
    UILabel *labelSubtitle;
    UILabel *labelSinceCreated;
    
    UILabel *labelComments;
}

@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelSubtitle;
@property (nonatomic, retain) IBOutlet UILabel *labelSinceCreated;
@property (nonatomic, retain) IBOutlet UILabel *labelComments;


-(void)redisplay;

@end
