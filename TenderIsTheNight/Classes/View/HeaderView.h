

#import <UIKit/UIKit.h>

@class HeaderView;
@protocol HeaderViewDelegate <NSObject>

@optional
- (void)headerView:(HeaderView *)headerView didSelectedSearchBth:(UIButton *)searchBtn;
- (void)headerView:(HeaderView *)headerView didSelectedsignInBtn:(UIButton *)signBtn;
- (void)headerView:(HeaderView *)headerView didSelectedEntryBtn:(UIButton *)entryBtn;
- (void)headerView:(HeaderView *)headerView didSelectedBannerBtn:(UIButton *)bannerBtn;

@end

@interface HeaderView : UIView

@property (strong, nonatomic) NSArray *bannerArray;
@property (strong, nonatomic) NSArray *entryArray;
@property (weak, nonatomic) id<HeaderViewDelegate>delegate;

//HOME的header
+ (instancetype)homeHeader;



@end
