//
//  ArticleTableViewCell.m
//  HackerNews
//
//  Created by Andrew Little on 11-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArticleTableViewCell.h"


@implementation ArticleTableViewCell

@synthesize labelTitle;
@synthesize labelSubtitle;
@synthesize labelSinceCreated;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
    
    [labelSubtitle release];
    [labelSinceCreated release];
    [labelTitle release];
}

@end
