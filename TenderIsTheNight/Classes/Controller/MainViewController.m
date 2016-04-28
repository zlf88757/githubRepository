

#import "MainViewController.h"
#import "HomeViewController.h"
#import "LuxuryViewController.h"
#import "ComposeViewController.h"
#import "LikeViewController.h"
#import "PersonViewController.h"
#import "MyTitleView.h"
#import "MyNavigationController.h"
#import "BottomBar.h"

@interface MainViewController ()<BottomBarDelegate>

@property (weak, nonatomic) BottomBar *bottomBar;
@property (weak, nonatomic) HomeViewController *home;
@property (weak, nonatomic) LuxuryViewController *luxury;
@property (weak, nonatomic) LikeViewController *like;
@property (weak, nonatomic) PersonViewController *person;
@property (weak, nonatomic) UIViewController *lastSelectedViewContoller;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 1.创建子控制器
    [self setupAllChildVcs];
    
    // 2.添加底部bar（自定义tabbar）
    [self setupBottomBar];
    
     CYGLog(@"bottomBar-----%@",self.bottomBar);
}

- (void)setupAllChildVcs
{
    HomeViewController *home = [[HomeViewController alloc] init];
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:home];
    [self addChildViewController:nav];
    home.navigationController.navigationBar.hidden = YES;
    self.home = home;
    
    
    LuxuryViewController *luxury = [[LuxuryViewController alloc] init];
    [self setupVc:luxury title:@"精选"];
    self.luxury = luxury;
    
    LikeViewController *like = [[LikeViewController alloc] init];
    [self setupVc:like title:@"消息"];
    self.like = like;
    
    PersonViewController *person = [[PersonViewController alloc] init];
    [self addChildViewController:person];
    self.person = person;
}

- (void)setupVc:(UIViewController *)vc title:(NSString *)title
{
    // 1.设置背景色
    //vc.view.backgroundColor = CYGRandomColor;
    
    // 2.设置标题
    MyTitleView *titleView = [[MyTitleView alloc]init];
    titleView.title = title;
    vc.navigationItem.titleView = titleView;
    
    // 3.包装一个导航控制器
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:vc];
    // 让nav成为self（MainViewController）的子控制器，能保证：self在，nav就在
    // 如果两个控制器互为父子关系，那么它们的view也应该互为父子关系
    [self addChildViewController:nav];
}

- (void)setupBottomBar
{
    BottomBar *bottomBar = [[BottomBar alloc] init];
    bottomBar.delegate = self;
    bottomBar.height = 49;
    bottomBar.width = self.view.width;
    bottomBar.x = 0;
    bottomBar.y = self.view.height - bottomBar.height;
    [self.view addSubview:bottomBar];
    self.bottomBar = bottomBar;
    self.bottomBar.plusBtnDelegate = self.home;
   
}

#pragma mark - BottomBarDelegate
- (void)bottomBar:(BottomBar *)bottomBar didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex
{

    // 1.移除旧控制器的view
    UIViewController *oldvc = self.childViewControllers[fromIndex];
    [oldvc.view removeFromSuperview];
    
    // 2.显示新控制器的view
    UIViewController *newvc = self.childViewControllers[toIndex];
    [self.view insertSubview:newvc.view atIndex:0];
    
    if (newvc == self.childViewControllers[0]) {
        self.bottomBar.plusBtnDelegate = self.home;
    }else if (newvc == self.childViewControllers[1]){
        self.bottomBar.plusBtnDelegate = self.luxury;
    }else if (newvc == self.childViewControllers[2]){
        self.bottomBar.plusBtnDelegate = self.like;
    }else if (newvc == self.childViewControllers[3]) {
        self.bottomBar.plusBtnDelegate = self.person;
    }
    
    
    
    CYGLog(@"-----1111");
    CYGLog(@"-----%@",newvc);
    if (newvc == self.childViewControllers[0]) {
        if (self.lastSelectedViewContoller == newvc) {
            [self.home refresh:YES];
        }else{
            [self.home refresh:NO];
        }
        
    }
    self.lastSelectedViewContoller = newvc;
 
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

























