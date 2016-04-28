

#import "HomeViewController.h"
#import "HeaderView.h"
#import "HomeCell.h"
#import "MJRefresh.h"
#import "MyHttpTool.h"
#import "MJExtension.h"
#import "HomeBannerModel.h"
#import "HomeEntryModel.h"
#import "HomeTopicModel.h"
#import "HomeSearchController.h"
#import "HomeSignInController.h"
#import "MapViewController.h"
#import "HomeSelectedController.h"
#import "MyNavigationController.h"
#import "MyTitleView.h"
#import "ComposeViewController.h"

@interface HomeViewController ()<HeaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //声明访问相册、照相机，成员变量
    UIImagePickerController *_pickerController;
}

/*首页专题数据数组*/
@property (strong, nonatomic) NSMutableArray *topicArray;
/*首页广告数据数组*/
@property (strong, nonatomic) NSMutableArray *bannerArray;
/*首页条目数据数组*/
@property (strong, nonatomic) NSMutableArray *entry_listArray;

@property (weak, nonatomic) UIButton *floatSearchBtn;

@property (assign, nonatomic) int page;

@end

@implementation HomeViewController
#pragma mark - 懒加载
- (NSArray *)topicArray
{
    if (_topicArray == nil) {
        _topicArray = [NSMutableArray array];
    }
    return _topicArray;
}
- (NSArray *)bannerArray
{
    if (_bannerArray == nil) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (NSArray *)entry_listArray
{
    if (_entry_listArray == nil) {
        _entry_listArray = [NSMutableArray array];
    }
    return _entry_listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //访问相册功能
    _pickerController=[[UIImagePickerController alloc]init];
    _pickerController.delegate=self;
    _pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;//来自图库;
    
    
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //这样y从屏幕顶端开始 不会空出20像素
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //MJ刷新
    [self setupMJRefresh];
}

- (void)setupFloatSearchBtn
{
    UIButton *floatBtn = [[UIButton alloc] init];
    floatBtn.x = 20;
    floatBtn.y = 25;
    floatBtn.width = 40;
    floatBtn.height = 40;
    floatBtn.alpha = 0;
    [floatBtn setImage:[UIImage imageNamed:@"ic_main_home_search_float_pressed"] forState:UIControlStateHighlighted];
    [floatBtn setImage:[UIImage imageNamed:@"ic_main_home_search_float"] forState:UIControlStateNormal];
    [floatBtn addTarget:self action:@selector(floatSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:floatBtn];
    self.floatSearchBtn = floatBtn;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.floatSearchBtn.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.floatSearchBtn.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)floatSearchBtnClick
{
    CYGLog(@"----floatSearchBtnClick");
    HomeSearchController *searchVc = [[HomeSearchController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)setupHeaderView
{
    HeaderView *headerView = [HeaderView homeHeader];
    headerView.bannerArray = self.bannerArray;
    headerView.entryArray = self.entry_listArray;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
}

- (void)setupMJRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
        
    }];
    
    //第一次先手动调用加载
    [self loadNewData];
}

- (void)loadNewData
{
    _page = 0;
    if (self.bannerArray.count>0) {
        [self.bannerArray removeAllObjects];
    }
    if (self.entry_listArray.count>0) {
        [self.entry_listArray removeAllObjects];
    }
    if (self.topicArray.count>0) {
        [self.topicArray removeAllObjects];
    }
    
    [MyHttpTool get:HomeBasePage params:@{@"page":@(0)} success:^(id responseObj) {
        
        //CYGLog(@"%@",responseObj);
        
        for (NSDictionary *dict in responseObj[@"data"][@"banner"]) {
            
            HomeBannerModel *bannerModel = [HomeBannerModel mj_objectWithKeyValues:dict];
            
            [self.bannerArray addObject:bannerModel];
        }
        
        for (NSDictionary *dict in responseObj[@"data"][@"entry_list"]) {
            
            HomeEntryModel *entryModel = [HomeEntryModel mj_objectWithKeyValues:dict];
            
            [self.entry_listArray addObject:entryModel];
        }
        
        for (NSDictionary *dict in responseObj[@"data"][@"topic"]) {
            
            HomeTopicModel *topicModel = [HomeTopicModel mj_objectWithKeyValues:dict];
            
            //CYGLog(@"%@",topicModel.id);
            
            [self.topicArray addObject:topicModel];
        }
        
        // 设置headerView
        [self setupHeaderView];
        
        //设置滑动是出现的搜索按钮
        [self setupFloatSearchBtn];
        
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
    
    [MyHttpTool get:HomeBasePage params:@{@"page":@(_page)} success:^(id responseObj) {
        
        //CYGLog(@"%@",responseObj);
        
        for (NSDictionary *dict in responseObj[@"data"][@"topic"]) {
            
            HomeTopicModel *topicModel = [HomeTopicModel mj_objectWithKeyValues:dict];
            
            topicModel.isSelected = NO;
            
            [self.topicArray addObject:topicModel];
        }
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        CYGLog(@"请求失败--%@", error);
        
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 回到顶部
- (void)refresh:(BOOL)fromSelf
{
    if (fromSelf) {
//        NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
//        
//        [self.tableView scrollToRowAtIndexPath:firstRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.topicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *cell = [HomeCell cellWithTableView:tableView];
    
    cell.newimgBlock = ^(int index,BOOL isSelected){
        
        HomeTopicModel *model = self.topicArray[indexPath.row];
        
        model.isSelected = isSelected;
        
        [self.topicArray replaceObjectAtIndex:index withObject:model];
        
    };
    
    cell.topicModel = self.topicArray[indexPath.row];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    CYGLog(@"-----didSelectRowAtIndexPath");
    HomeCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.newimage.hidden = YES;
    cell.newimgBlock((int)indexPath.row,cell.newimage.hidden);
    
    HomeTopicModel *model = self.topicArray[indexPath.row];
    
    HomeSelectedController *homeSelVc = [[HomeSelectedController alloc] init];
    
    homeSelVc.ID = model.id;
    
    [self presentViewController:homeSelVc animated:YES completion:nil];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float searchAlpha = (self.tableView.contentOffset.y - 70)/70;
    self.floatSearchBtn.alpha = searchAlpha;
}

#pragma mark-HeaderViewDelegate

- (void)headerView:(HeaderView *)headerView didSelectedSearchBth:(UIButton *)searchBtn
{
    [self floatSearchBtnClick];
}

- (void)headerView:(HeaderView *)headerView didSelectedsignInBtn:(UIButton *)signBtn
{
    CYGLog(@"-----didSelectedsignInBtn");
    HomeSignInController *signInVc = [[HomeSignInController alloc]init];
    [self.navigationController pushViewController:signInVc animated:YES];
}

//接口未抓 先跳到HomeSelectedController测试
- (void)headerView:(HeaderView *)headerView didSelectedBannerBtn:(UIButton *)bannerBtn
{
    int randomNum = arc4random()%(self.topicArray.count);
    
    HomeTopicModel *model = self.topicArray[randomNum];
    
    HomeSelectedController *homeSelVc = [[HomeSelectedController alloc] init];
    
    homeSelVc.ID = model.id;
    
    [self presentViewController:homeSelVc animated:YES completion:nil];
}

//接口未抓 先跳到HomeSelectedController测试
- (void)headerView:(HeaderView *)headerView didSelectedEntryBtn:(UIButton *)entryBtn
{
    int randomNum = arc4random()%(self.topicArray.count);
    
    HomeTopicModel *model = self.topicArray[randomNum];
    
    HomeSelectedController *homeSelVc = [[HomeSelectedController alloc] init];
    
    homeSelVc.ID = model.id;
    
    [self presentViewController:homeSelVc animated:YES completion:nil];
}

#pragma mark-BottomBarPlusBtnDelegate
- (void)bottomBar:(BottomBar *)bottomBar didSelectedPlusButton:(UIButton *)button
{
//    //访问相册功能
//    _pickerController=[[UIImagePickerController alloc]init];
//    _pickerController.delegate=self;
//    _pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;//来自图库;
    [self presentViewController:_pickerController animated:YES completion:^{
        
    }];
}

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








