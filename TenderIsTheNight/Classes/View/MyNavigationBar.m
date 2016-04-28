

#import "MyNavigationBar.h"

@implementation MyNavigationBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIButton *button in self.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        
        if (button.centerX < self.width * 0.5) {// 左边的按钮
            button.x = 0;
        }else if (button.centerX-1.7 > self.width * 0.5) { // 右边的按钮 //6plus button.centerX > self.width * 0.5
            CYGLog(@"button----%f",button.centerX);
            CYGLog(@"MyNavigationBar----%f",self.width * 0.5);
            button.x = self.width - button.width;
        }
            
        
    }
}

@end
