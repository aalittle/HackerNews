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

- (void)dealloc
{
    [labelSubtitle release];
    [labelSinceCreated release];
    [labelTitle release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background_beige"]] autorelease];
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background_lightgrey"]] autorelease];

        //setup the main label
        self.labelTitle = [[[UILabel alloc] initWithFrame:CGRectMake(9.0, 0.0, 258.0, 48.0)] autorelease];
        self.labelTitle.numberOfLines = 3;
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        self.labelTitle.textColor = [UIColor darkGrayColor];
        self.labelTitle.shadowColor = [UIColor colorWithRed:249.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        self.labelTitle.shadowOffset = CGSizeMake(0.0, 1.0);
        self.labelTitle.minimumFontSize = 10.0;
        self.labelTitle.lineBreakMode = UILineBreakModeTailTruncation;
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        
        //setup the subtitle label
        self.labelSubtitle = [[[UILabel alloc] initWithFrame:CGRectMake(9.0, 48.0, 287.0, 21.0)] autorelease];
        self.labelSubtitle.numberOfLines = 1;
        self.labelSubtitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        self.labelSubtitle.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        self.labelSubtitle.minimumFontSize = 10.0;
        self.labelSubtitle.lineBreakMode = UILineBreakModeTailTruncation;
        self.labelSubtitle.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:labelSubtitle];

        //setup the time since label
        self.labelSinceCreated = [[[UILabel alloc] initWithFrame:CGRectMake(258.0, 0.0, 53.0, 21.0)] autorelease];
        self.labelSinceCreated.numberOfLines = 1;
        self.labelSinceCreated.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        self.labelSinceCreated.textAlignment = UITextAlignmentRight;
        self.labelSinceCreated.textColor = [UIColor colorWithRed:56.0/255.0 green:119.0/255.0 blue:217.0/255.0 alpha:1.0];
        self.labelSinceCreated.minimumFontSize = 10.0;
        self.labelSinceCreated.lineBreakMode = UILineBreakModeTailTruncation;
        self.labelSinceCreated.backgroundColor = [UIColor clearColor];
        self.labelSinceCreated.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [self.contentView addSubview:labelSinceCreated];

    }
    return self;
}

-(void)redisplay {
    
    [self setNeedsDisplay];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
