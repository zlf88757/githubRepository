

#import <UIKit/UIKit.h>

typedef void (^ChangeUserIconBlock)(NSString *,NSString *);

@class SinaLoginModel;
@interface LoginViewController : UIViewController

@property (strong, nonatomic) SinaLoginModel *model;

@property (copy, nonatomic) ChangeUserIconBlock changeBlock;

@end
