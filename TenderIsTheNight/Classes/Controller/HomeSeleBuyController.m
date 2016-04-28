

#import "HomeSeleBuyController.h"
#import "MyTitleView.h"
@interface HomeSeleBuyController ()<UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;

@end

@implementation HomeSeleBuyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyTitleView *titleView = [[MyTitleView alloc] init];
    titleView.title = @"宝贝详情";
    self.navigationItem.titleView = titleView;
    
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.width = 30;
    leftBtn.height = 30;
    [leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.width = 30;
    rightBtn.height = 30;
    [rightBtn setImage:[UIImage imageNamed:@"ic_close_White"] forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [rightBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -50, ScreenWidth, ScreenHeight-14)];
    webView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:_strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    //遮住webview上面的导航条
    UILabel *label = [[UILabel alloc]init];
    label.width = ScreenWidth;
    label.height = 50;
    label.backgroundColor = [UIColor whiteColor];
    [webView.scrollView addSubview:label];
    
}

- (void)goback
{
    [self.webView goBack];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
