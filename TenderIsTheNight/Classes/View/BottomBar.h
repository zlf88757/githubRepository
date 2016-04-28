

#import <UIKit/UIKit.h>
@class BottomBar;
@protocol BottomBarDelegate <NSObject>

@optional
- (void)bottomBar:(BottomBar *)bottomBar didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex;

@end

@protocol BottomBarPlusBtnDelegate <NSObject>

@optional
- (void)bottomBar:(BottomBar *)bottomBar didSelectedPlusButton:(UIButton *)button;
@end

@interface BottomBar : UIView
@property (weak, nonatomic) id<BottomBarDelegate>delegate;

@property (weak, nonatomic) id<BottomBarPlusBtnDelegate>plusBtnDelegate;

@end
