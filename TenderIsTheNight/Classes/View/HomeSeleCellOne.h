

#import <UIKit/UIKit.h>

@class HomeSeleCellOne;
@protocol HomeSeleCellOnelDelegate <NSObject>

@optional
- (void)homeSeleCellOne:(HomeSeleCellOne *)cell didClickedButton:(UIButton *)button strUrl:(NSString *)strUrl;

@end

@class HomeSeleProductModel;
@interface HomeSeleCellOne : UITableViewCell

@property (weak, nonatomic) id<HomeSeleCellOnelDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshCell:(HomeSeleProductModel *)model index:(int)index;

@end
