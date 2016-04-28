

#import "LuxuryGoodsDetailController.h"
#import "MainViewController.h"
#import "BottomBar.h"
#import "MyTitleView.h"
@interface LuxuryGoodsDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) BottomBar *bar;
@end

@implementation LuxuryGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.width = 30;
    leftBtn.height = 30;
    [leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    MyTitleView *titleView = [[MyTitleView alloc] init];
    titleView.title = @"好物详情";
    self.navigationItem.titleView = titleView;
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -45, ScreenWidth, ScreenHeight)];
    webView.backgroundColor = [UIColor whiteColor];
   
    //遮住webview上面的导航条
    UILabel *label = [[UILabel alloc]init];
    label.width = ScreenWidth;
    label.height = 50;
    label.backgroundColor = [UIColor whiteColor];
    [webView.scrollView addSubview:label];
    
    NSURL *url = [NSURL URLWithString:_strUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    webView.delegate = self;
    
    [self.view addSubview:webView];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MainViewController *mainVc = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    CYGLog(@"[mainVc.view.subviews lastObject]---%@",[mainVc.view.subviews lastObject]);
    
    BottomBar *bar = [mainVc.view.subviews lastObject];
    self.bar = bar;
    bar.hidden = YES;
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.bar.hidden = NO;
}



@end
