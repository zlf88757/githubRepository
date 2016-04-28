

#import "MyNavigationController.h"
//#import "MyNavigationBar.h"
@interface MyNavigationController ()

@end

@implementation MyNavigationController

+ (void)initialize
{
    CYGLog(@"MyNavigationController----initialize");
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置导航栏背景
    [appearance setBackgroundImage:[UIImage imageWithColor:CYGColorRGBA(250, 110, 110, 1)] forBarMetrics:UIBarMetricsDefault];
//    [appearance setBackgroundImage:[UIImage resizedImage:@"bg_personal_popup_remind.9"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 替换为自定义的导航栏
//    [self setValue:[[MyNavigationBar alloc]init] forKey:@"navigationBar"];
    
}

@end
