

#import <UIKit/UIKit.h>

@interface LikeHotCell : UITableViewCell

@property (copy, nonatomic) NSString *photoUrl;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
