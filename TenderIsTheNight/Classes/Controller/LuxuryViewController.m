
#import "LuxuryViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MyHttpTool.h"
#import "LuxuryStatusFrameModel.h"
#import "LuxuryStatusModel.h"
#import "LuxuryCell.h"
#import "LuxuryGoodsDetailController.h"
#import "UMSocial.h"
#import "MainViewController.h"
#import "MyTitleView.h"
#import "MapViewController.h"
#import "ComposeViewController.h"

@interface LuxuryViewController ()<LuxuryCellDelegate,UMSocialUIDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //声明访问相册、照相机，成员变量
    UIImagePickerController *_pickerController;
}
@property (weak, nonatomic) BottomBar *bar;

@property (strong, nonatomic) NSMutableArray *statusFrameModels;
@property (assign, nonatomic) int page;

@end

@implementation LuxuryViewController

#pragma mark - 初始化
- (NSMutableArray *)statusFrameModels
{
    if (_statusFrameModels == nil) {
        _statusFrameModels = [NSMutableArray array];
    }
    return _statusFrameModels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *mapBtn = [UIBarButtonItem itemWithImageName:@"UMS_place_off@2x" target:self action:@selector(mapBtnClick:)];
    self.navigationItem.rightBarButtonItem = mapBtn;
    
    //MJ刷新
    [self setupMJRefresh];
    
    
}

- (void)mapBtnClick:(UIBarButtonItem *)mapBtn
{
    MapViewController *mapVc = [[MapViewController alloc] init];
    [self.navigationController pushViewController:mapVc animated:YES];
}

- (void)setupMJRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loadNewData];
        
    }];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        [self loadMoreData];
        
    }];
    
    [self loadNewData];
}

- (void)loadNewData
{
    _page = 0;
    
    if (self.statusFrameModels.count>0) {
        [self.statusFrameModels removeAllObjects];
    }
    
    [MyHttpTool post:LuxuryBasePage params:@{@"page":@(_page)} success:^(id responseObj) {
        
       // CYGLog(@"%@",responseObj);
        for (NSDictionary *dict in responseObj[@"data"][@"list"]) {
            LuxuryStatusFrameModel *frameModel = [[LuxuryStatusFrameModel alloc]init];
            LuxuryStatusModel *statusModel = [LuxuryStatusModel mj_objectWithKeyValues:dict];
            frameModel.statusModel = statusModel;
            
            //设置foucus的选中状态
            //因为点了关注还要发请求告诉服务器，所以这里先不用数据中的is_collect
            frameModel.focusIsSelected = NO;
            frameModel.likesIsSelected = NO;
            
            [self.statusFrameModels addObject:frameModel];
        }
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSError *error) {
        CYGLog(@"请求失败--%@", error);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData
{
    _page++;
    
    [MyHttpTool post:LuxuryBasePage params:@{@"page":@(_page)} success:^(id responseObj) {
        
        for (NSDictionary *dict in responseObj[@"data"][@"list"]) {
            LuxuryStatusFrameModel *frameModel = [[LuxuryStatusFrameModel alloc]init];
            LuxuryStatusModel *statusModel = [LuxuryStatusModel mj_objectWithKeyValues:dict];
            frameModel.statusModel = statusModel;
            
            frameModel.focusIsSelected = NO;
            frameModel.likesIsSelected = NO;
            
            [self.statusFrameModels addObject:frameModel];
        }
        
       
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        CYGLog(@"请求失败--%@", error);
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrameModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LuxuryCell *cell = [LuxuryCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    //点击时不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.index = (int)indexPath.row;
    
    //foucsBtnBlock
    cell.myblock = ^(int index,BOOL isSelected){
        
        LuxuryStatusFrameModel *frameModel = self.statusFrameModels[indexPath.row];
        
        frameModel.focusIsSelected = isSelected;
        
        [self.statusFrameModels replaceObjectAtIndex:index withObject:frameModel];
    };
    
    //likesBtnBlock
    cell.likesBlock = ^(int index,BOOL isSelected){
        LuxuryStatusFrameModel *frameModel = self.statusFrameModels[indexPath.row];
        
        frameModel.likesIsSelected = isSelected;
        
        [self.statusFrameModels replaceObjectAtIndex:index withObject:frameModel];
    };
    
    cell.frameModel = self.statusFrameModels[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LuxuryStatusFrameModel *frameModel = self.statusFrameModels[indexPath.row];
    return frameModel.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CYGLog(@"didSelectRowAtIndexPath----");
    
    LuxuryStatusFrameModel *frameModel = self.statusFrameModels[indexPath.row];
    LuxuryStatusModel *model = frameModel.statusModel;
    
    LuxuryGoodsDetailController *detailVc = [[LuxuryGoodsDetailController alloc] init];
    
    detailVc.strUrl = model.share_url;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark-LuxuryCellDelegate
- (void)luxuryCell:(LuxuryCell *)cell didClickedButton:(LuxuryCellButtonType)buttonType info:(NSDictionary *)info
{
    switch (buttonType) {
        case LuxuryCellButtonTypeShare:
            [self share:info];
            break;
        case LuxuryCellButtonTypeLike:
        {
            
        }
            break;
        case LuxuryCellButtonTypeBuy:
        {
            
        }
            break;
        default:
            break;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MainViewController *mainVc = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    CYGLog(@"[mainVc.view.subviews lastObject]---%@",[mainVc.view.subviews lastObject]);
    
    BottomBar *bar = [mainVc.view.subviews lastObject];
    self.bar = bar;
    bar.hidden = NO;
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)share:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"%@\n%@",info[@"text"],info[@"url"]];
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    [UMSocialData defaultData].extConfig.wechatSessionData.url = info[@"url"];
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = info[@"url"];
    //设置微信好友title方法为
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
    //设置微信朋友圈title方法替换平台参数名即可
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈title";
    
    //QQ设置点击分享内容跳转链接调用下面的方法
    [UMSocialData defaultData].extConfig.qqData.url = info[@"url"];
    //Qzone设置点击分享内容跳转链接替换平台参数名即可
//    [UMSocialData defaultData].extConfig.qzoneData.url = info[@"url"];
    //QQ设置title方法为
//    [UMSocialData defaultData].extConfig.qqData.title = @"QQ分享title";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:text
                                     shareImage:info[@"image"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    
    
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:info[@"text"] image:info[@"image"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            CYGLog(@"分享成功！");
//        }
//    }];
    

     //使用默认分享界面分享URL图片
    //    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];
    //分享url音乐
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeMusic url:@"http://music.huoxing.com/upload/20130330/1364651263157_1085.mp3"];
    
    //分享url视频
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:@"http://v.youku.com/v_show/id_XNjQ1NjczNzEy.html?f=21207816&ev=2"];
    
    self.bar.hidden = YES;
}

- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    self.bar.hidden = NO;
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















