

#import <UIKit/UIKit.h>

typedef enum {
    LuxuryCellButtonTypeShare = 300,//分享
    LuxuryCellButtonTypeLike,//喜欢
    LuxuryCellButtonTypeBuy  //购买
    
}LuxuryCellButtonType;
@class LuxuryCell;
@protocol LuxuryCellDelegate <NSObject>

@optional
- (void)luxuryCell:(LuxuryCell *)cell didClickedButton:(LuxuryCellButtonType)buttonType info:(NSDictionary *)info;

@end


typedef void (^foucsBtnBlock)(int,BOOL);
typedef void (^likesBtnBlock)(int,BOOL);

@class LuxuryStatusFrameModel;
@interface LuxuryCell : UITableViewCell

@property (strong, nonatomic) LuxuryStatusFrameModel *frameModel;

@property (assign, nonatomic) int index;

@property (copy, nonatomic) foucsBtnBlock myblock;
@property (copy, nonatomic) likesBtnBlock likesBlock;

@property (weak, nonatomic) id<LuxuryCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
