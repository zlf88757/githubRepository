

#import "ComposeViewController.h"
#import "MyTitleView.h"
#import "MainViewController.h"
#import "BottomBar.h"
#import "MyTextView.h"

@interface ComposeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //声明访问相册、照相机，成员变量
    UIImagePickerController *_pickerController;
}
@property (weak, nonatomic) BottomBar *bar;

@end

@implementation ComposeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MainViewController *mainVc = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    [self setupComposeInfo];
}

- (void)setupNavBar
{
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.width = 30;
    leftBtn.height = 30;
    [leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.width = 40;
    rightBtn.height = 30;
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(compose) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    MyTitleView *titleView = [[MyTitleView alloc] init];
    titleView.title = @"发布我的宝贝";
    self.navigationItem.titleView = titleView;
    
    
    
}

- (void)setupComposeInfo
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.x = 20;
    imageView.y = 20;
    imageView.width = 100;
    imageView.height = imageView.width;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = _img;
    [self.view addSubview:imageView];
    
    UIView *line = [[UIView alloc]init];
    line.x = imageView.x;
    line.y = CGRectGetMaxY(imageView.frame)+20;
    line.width = ScreenWidth - 2*line.x;
    line.height = 1;
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    MyTextView *textView = [[MyTextView alloc]init];
    textView.x = line.x;
    textView.y = CGRectGetMaxY(line.frame) + 20;
    textView.width = line.width;
    textView.height = textView.width;
    textView.placehoder = @"分享你的使用心得";
    [self.view addSubview:textView];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)compose
{
    CYGLog(@"post");
}

@end












