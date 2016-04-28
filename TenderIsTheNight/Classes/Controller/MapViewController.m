

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "MainViewController.h"
#import "BottomBar.h"

@interface MapViewController ()<MAMapViewDelegate,AMapSearchDelegate>

@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) AMapSearchAPI *search;
//存放poi的数组
@property (strong, nonatomic) NSArray *pois;
//存放大头针的数组
@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *searchBtn;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (weak, nonatomic) BottomBar *bar;

@end

@implementation MapViewController

- (CLLocation *)currentLocation
{
    if (_currentLocation == nil) {
        _currentLocation = [[CLLocation alloc] init];
    }
    
    return _currentLocation;
}
- (NSMutableArray *)annotations
{
    if(_annotations == nil)
    {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _pois = [NSArray array];
    
    [self setupTopView];
    
    [self createMap];
}

#pragma 隐藏底部bar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MainViewController *mainVc = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    CYGLog(@"[mainVc.view.subviews lastObject]---%@",[mainVc.view.subviews lastObject]);
    
    BottomBar *bar = [mainVc.view.subviews lastObject];
    self.bar = bar;
    bar.hidden = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.bar.hidden = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark-设置顶部搜索view
- (void)setupTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    topView.backgroundColor = CYGColor(250, 110, 110);
    [self.view addSubview:topView];
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.x = 10;
    backBtn.y = 28;
    backBtn.width = 30;
    backBtn.height = 30;
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 27, ScreenWidth-120, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"搜索附近的商店吧";
    _textField.font = [UIFont systemFontOfSize:13];
    [topView addSubview:_textField];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(_textField.x+_textField.width+12, 27, 40, 30);
    _searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(roundSearch) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topView addSubview:_searchBtn];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-设置地图
- (void)createMap
{
    [MAMapServices sharedServices].apiKey = MapAPIKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    _mapView.delegate = self;
    _mapView.language = MAMapLanguageZhCN;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    //设置当前地图缩放级别 越大离得越近
    [_mapView setZoomLevel:16.1 animated:YES];
    
    
    [self.view addSubview:_mapView];
    
    [AMapSearchServices sharedServices].apiKey = MapAPIKEY;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //创建关键字搜索请求对象
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = @"";
    request.requireExtension = YES;
    //发起关键字搜索
    [_search AMapPOIKeywordsSearch:request];
}

//搜索回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    if(response.pois.count == 0)
    {
        return;
    }
    
    //移除地图上之前的大头针
    [_mapView removeAnnotations:_annotations];
    //移除大头针数组中的大头针
    [self.annotations removeAllObjects];
    //处理搜索结果
    self.pois = response.pois;
    
    for(AMapPOI *poi in _pois)
    {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        annotation.title = poi.name;
        annotation.subtitle = poi.address;
        //大头针数组添加大头针
        [_annotations addObject:annotation];
        //地图添加大头针
        [_mapView addAnnotation:annotation];
        //将大头针中心作为地图中心
        _mapView.centerCoordinate = annotation.coordinate;
    }
}
//位置或者设备方向更新后调用此接口，会不断刷新
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    self.currentLocation = [userLocation.location copy];
}
//附近搜索
- (void)roundSearch
{
    [_textField resignFirstResponder];
    //创建关键字搜索请求对象
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    
    request.keywords = _textField.text;
    request.requireExtension = YES;
    [self.search AMapPOIAroundSearch:request];
    
    //清空搜索框
    _textField.text = @"";
}
//设置大头针view
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAPinAnnotationView *view = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MAPinAnnotationView"];
        if(view == nil)
        {
            view = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MAPinAnnotationView"];
            view.canShowCallout = YES;
            
        }
        return view;
    }
    return nil;
}
@end
