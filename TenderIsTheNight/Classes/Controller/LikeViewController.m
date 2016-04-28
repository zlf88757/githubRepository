

#import "LikeViewController.h"
#import "LikeMessageCell.h"
#import "LikeHotCell.h"
#import "MyHttpTool.h"
#import "MyTitleView.h"
#import "ComposeViewController.h"

@interface LikeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //声明访问相册、照相机，成员变量
    UIImagePickerController *_pickerController;
}

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *imageArray;

@property (strong, nonatomic) NSMutableArray *hotImgArray;

@end

@implementation LikeViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.tableView.sectionHeaderHeight = 60;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorColor = CYGColorRGBA(235, 235, 241, 0.8);
    
    [self loadNewData];
    
}

- (void)loadNewData
{
    [MyHttpTool post:LikePage params:nil success:^(id responseObj) {
        
        for (NSDictionary *dict in responseObj[@"data"][@"element"]) {
            
            NSString *photoUrl = dict[@"photo"];
            
            [self.hotImgArray addObject:photoUrl];
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"新的粉丝",@"新的评论",@"新的喜欢",@"新的奖励",@"通知"];
    }
    return _titleArray;
}
- (NSArray*)imageArray
{
    if (!_imageArray) {
        _imageArray = @[@"ic_setting_join_us",@"ic_pimage_desc_focused",@"ic_pesonal_like",@"ic_pimage_edit_effect_filter_checked",@"ic_price"];
    }
    return _imageArray;
}
- (NSMutableArray *)hotImgArray
{
    if (!_hotImgArray) {
        _hotImgArray = [NSMutableArray array];
    }
    return _hotImgArray;
}


#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
    label.backgroundColor = [UIColor whiteColor];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth-40, 50)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.textColor = [UIColor grayColor];
    label2.text = @"热门活动";
    [view addSubview:label];
    [view addSubview:label2];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 200;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
       return 5;
    }
    return self.hotImgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        LikeMessageCell *cell = [LikeMessageCell cellWithTableView:tableView];
        
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        LikeHotCell *cell = [LikeHotCell cellWithTableView:tableView];
        cell.photoUrl = self.hotImgArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

//让cell底下的线左边无缝隙 底下俩方法都要有
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.section == 0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }else{
        //设置section1的cell的分割线 让它居左居右100，居上居下10，这样就看不见分割线了
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsMake(10, 100, 10, 100)];
        }
    }
    
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
//修改_pickerController的navigationItem
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
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
