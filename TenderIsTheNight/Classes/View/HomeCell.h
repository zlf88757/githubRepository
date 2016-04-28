

#import <UIKit/UIKit.h>

typedef void (^newimgHidden)(int,BOOL);

@class HomeTopicModel;
@interface HomeCell : UITableViewCell

@property (strong, nonatomic) HomeTopicModel *topicModel;

@property (weak, nonatomic) UIImageView *newimage;

@property (copy, nonatomic) newimgHidden newimgBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
