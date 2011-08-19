/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
#import <UIKit/UIKit.h>


@interface PRPNibBasedTableViewCell : UITableViewCell {}

+ (UINib *)nib;
+ (NSString *)nibName;

+ (NSString *)cellIdentifier;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;

@end