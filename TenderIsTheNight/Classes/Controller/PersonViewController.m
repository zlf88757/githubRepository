

#import "PersonViewController.h"
#import "LoginViewController.h"
#import "UIButton+WebCache.h"
#import "MyTitleView.h"
#import "ComposeViewController.h"

@interface PersonViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //声明访问相册、照相机，成员变量
    UIImagePickerController *_pickerController;
}
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userIconBtn.layer.cornerRadius = self.userIconBtn.width/2;
    self.userIconBtn.layer.masksToBounds = YES;
    
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    
    loginVc.changeBlock = ^(NSString *iconUrl,NSString *userName){
        
        [self.userIconBtn sd_setImageWithURL:[NSURL URLWithString:iconUrl] forState:UIControlStateNormal];
        self.userNameLb.text = userName;
    };
    
    [self presentViewController:loginVc animated:YES completion:nil];
    
}



- (IBAction)userIconClick:(UIButton *)sender {
}

#pragma mark-BottomBarPlusBtnDelegate
- (void)bottomBar:(BottomBar *)bottomBar didSelectedPlusButton:(UIButton *)button
{
    //访问相册功能
    _pickerController=[[UIImagePickerController alloc]init];
    _pickerController.delegate=self;
    _pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;//来自图库;
    [self presentViewController:_pickerController animated:YES completion:^{
        
    }];
}

//修改_pickerController的navigationItem
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    // 事件驱动型控件:ValueChanged
    NSArray *array = @[@"拍照",@"相册"];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    
    // 设置初始选中下标
    [segment setSelectedSegmentIndex:1];
    
    segment.tintColor = [UIColor whiteColor];
    
    [segment addTarget:self action:@selector(pressSegment:) forControlEvents:UIControlEventValueChanged];
    
    segment.width = 100;
    segment.height = 30;
    
    viewController.navigationItem.titleView = segment;
}
- (void)pressSegment:(UISegmentedControl *)segment
{
    // 选中下标
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self takePhoto];
            break;
            
        default:
            break;
    }
    
}
- (void)takePhoto
{
    //访问照相机
    _pickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
    //判断照相机功能是否可用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _pickerController=[[UIImagePickerController alloc]init];
        _pickerController.delegate=self;
        //设置拍照后的照片是否允许编辑
        _pickerController.allowsEditing=YES;
        //设置访问照相机
        
        [self presentViewController:_pickerController animated:YES completion:^{
            
        }];
        
    }
    else
    {
        //如果照相功能不可用
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"照相功能不可用!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //    [UIAlertController alertControllerWithTitle:@"警告" message:@"照相功能不可用!" preferredStyle:UIAlertControllerStyleAlert];
        //        [alert]
        [alert show];
        
    }
}
//选中相册中的图片时，调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    ComposeViewController *compose = [[ComposeViewController alloc]init];
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //相机调用
        CYGLog(@"%@",[info allKeys]);
        //UIImagePickerControllerEditedImage 编辑后的图片
        //UIImagePickerControllerOriginalImage 原始图片
        
        
        //获得拍照后的照片
        UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        compose.img=image;
        //隐藏拍照页面
        [picker dismissViewControllerAnimated:YES completion:^{
            
            
            [self.navigationController pushViewController:compose animated:YES];
        }];
        //将拍照后的结果保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        
    }
    else
    {
        //相册调用
        CYGLog(@"%@",[info allKeys]);
        //获得选中的图片对象
        UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
       compose.img=image;
        //隐藏相册
        [picker dismissViewControllerAnimated:YES completion:^{
            
            [self.navigationController pushViewController:compose animated:YES];
            
        }];
    }
    
    
    
    
}

@end
