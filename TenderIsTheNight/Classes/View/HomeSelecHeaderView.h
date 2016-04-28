
#import <UIKit/UIKit.h>
@class HomeSelectedModel;
@interface HomeSelecHeaderView : UIView

@property (strong, nonatomic) HomeSelectedModel *model;

@property (strong, nonatomic) UIImage *img;

//HomeSelected的header
+ (instancetype)homeSelectedHeader;

@end
