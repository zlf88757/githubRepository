

#import <UIKit/UIKit.h>

@class HomeSeleCellTwo;
@protocol HomeSeleCellTwolDelegate <NSObject>

@optional
- (void)homeSeleCellTwo:(HomeSeleCellTwo *)cell didClickedButton:(UIButton *)button strUrl:(NSString *)strUrl;

@end

@class HomeSeleProductModel;
@interface HomeSeleCellTwo : UITableViewCell

@property (weak, nonatomic) id<HomeSeleCellTwolDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshCell:(HomeSeleProductModel *)model index:(int)index;

@end



