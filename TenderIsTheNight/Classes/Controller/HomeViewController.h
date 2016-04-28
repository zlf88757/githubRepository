

#import <UIKit/UIKit.h>
#import "BottomBar.h"
@interface HomeViewController : UITableViewController<BottomBarPlusBtnDelegate>
- (void)refresh:(BOOL)fromSelf;
@end
