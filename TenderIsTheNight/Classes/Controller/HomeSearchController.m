

#import "HomeSearchController.h"
#import "MainViewController.h"
#import "BottomBar.h"
#import "CYGSearchBar.h"
@interface HomeSearchController ()<UITextFieldDelegate>
@property (weak, nonatomic) BottomBar *bar;
@end

@implementation HomeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.width = 30;
    leftBtn.height = 30;
    [leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    CYGSearchBar *searchBar = [CYGSearchBar searchBar];
    searchBar.placeholder = @"搜索感兴趣的专题或单品";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField endEditing:YES];
    
    return YES;
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
