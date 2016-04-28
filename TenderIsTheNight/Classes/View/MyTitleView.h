

#import <UIKit/UIKit.h>
//MyTitleView继承UIButton 是因为这样可以给titleView很方便的既设置image又设置文字
@interface MyTitleView : UIButton
@property (copy, nonatomic) NSString *title;
@end
