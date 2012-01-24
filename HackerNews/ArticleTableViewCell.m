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
@synthesize labelComments;

- (void)dealloc
{
    [labelSubtitle release];
    [labelSinceCreated release];
    [labelTitle release];
    [labelComments release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background_check@2x"]] autorelease];
        //self.backgroundView = background;

        //UIImageView *selectedBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_texture"]] autorelease]; 
        //selectedBackground.contentMode = UIViewContentModeScaleAspectFill;
        //self.selectedBackgroundView = selectedBackground;

        //setup the main label
        self.labelTitle = [[[UILabel alloc] initWithFrame:CGRectMake(9.0, 0.0, 258.0, 48.0)] autorelease];
        self.labelTitle.numberOfLines = 3;
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        self.labelTitle.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
        self.labelTitle.shadowColor = [UIColor colorWithRed:249.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        self.labelTitle.shadowOffset = CGSizeMake(0.0, 1.0);
        self.labelTitle.minimumFontSize = 10.0;
        self.labelTitle.lineBreakMode = UILineBreakModeTailTruncation;
        self.labelTitle.backgroundColor = [UIColor clearColor];
        self.labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.labelTitle];
        
        //setup the subtitle label
        self.labelSubtitle = [[[UILabel alloc] initWithFrame:CGRectMake(9.0, 42.0, 270.0, 21.0)] autorelease];
        self.labelSubtitle.numberOfLines = 1;
        self.labelSubtitle.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        self.labelSubtitle.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        self.labelSubtitle.minimumFontSize = 10.0;
        self.labelSubtitle.lineBreakMode = UILineBreakModeTailTruncation;
        self.labelSubtitle.backgroundColor = [UIColor clearColor];
        self.labelSubtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;

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
                
        //add a comments bubble
        UIImageView *commentBubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_bubble_3d"]];
        commentBubble.frame = CGRectMake(292.0, 44.0, 22.0, 22.0);
        commentBubble.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:commentBubble];
        
        //setup the Comment count label
        self.labelComments = [[[UILabel alloc] initWithFrame:CGRectMake(293.0, 45.0, 20.0, 14.0)] autorelease];
        self.labelComments.numberOfLines = 1;
        self.labelComments.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        self.labelComments.textAlignment = UITextAlignmentCenter;
        self.labelComments.textColor = [UIColor colorWithWhite:0.50 alpha:1.0];
        self.labelComments.minimumFontSize = 9.0;
        self.labelComments.lineBreakMode = UILineBreakModeTailTruncation;
        self.labelComments.backgroundColor = [UIColor clearColor];
        self.labelComments.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [self.contentView addSubview:self.labelComments];
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
