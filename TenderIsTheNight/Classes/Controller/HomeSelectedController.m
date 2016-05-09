

#import "HomeSelectedController.h"
#import "MyHttpTool.h"
#import "HomeSelectedModel.h"
#import "HomeSeleProductModel.h"
#import "MJExtension.h"
#import "HomeSelecHeaderView.h"
#import "HomeSeleCellOne.h"
#import "HomeSeleCellTwo.h"
#import "MyTitleView.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "HomeSeleBuyController.h"

@interface HomeSelectedController ()<UITableViewDataSource,UITableViewDelegate,HomeSeleCellOnelDelegate,HomeSeleCellTwolDelegate>

@property (strong, nonatomic) NSArray *productArray;

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UIView *topview;

@property (weak, nonatomic) UIView *sectionView;

@property (weak, nonatomic) UIImage *shareImg;
@property (copy, nonatomic) NSString *shareText;
@property (copy, nonatomic) NSString *shareTitle;
@property (copy, nonatomic) NSString *shareUrl;

@end

@implementation HomeSelectedController

- (NSArray *)productArray
{
    if (!_productArray) {
        _productArray = [NSArray array];
    }
    return _productArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    //MJ刷新
    [self loadData];
    
}

- (void)setupUI
{
    //这样y从屏幕顶端开始 不会空出20像素
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    MyTitleView *titleView = [[MyTitleView alloc] init];
    titleView.title = @"购物清单";
    titleView.centerX = topview.centerX;
    titleView.centerY = topview.centerY + 7;
    [topview addSubview:titleView];
    topview.backgroundColor = CYGColor(250, 110, 110);
    topview.alpha = 0;
    [self.view addSubview:topview];
    self.topview = topview;
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.x = 10;
    backBtn.y = 25;
    backBtn.width = 30;
    backBtn.height = 30;
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *shareBtn = [[UIButton alloc]init];
    shareBtn.width = 30;
    shareBtn.height = 30;
    shareBtn.x = ScreenWidth - shareBtn.width - 10;
    shareBtn.y = 25;
    [shareBtn setImage:[UIImage imageNamed:@"homeseletop_share_1@2x"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    
    UIView *sectionView = [self createSectionView];
    sectionView.y = 64;
    sectionView.width = ScreenWidth;
    sectionView.height = 50;
    [self.view addSubview:sectionView];
    sectionView.hidden = YES;
    self.sectionView = sectionView;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareBtnClick
{
    NSString *text = [NSString stringWithFormat:@"%@\n%@",self.shareText,self.shareUrl];
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    //设置微信好友title方法为
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
    //设置微信朋友圈title方法替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;
    
    //QQ设置点击分享内容跳转链接调用下面的方法
    [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
    //Qzone设置点击分享内容跳转链接替换平台参数名即可
    //    [UMSocialData defaultData].extConfig.qzoneData.url = info[@"url"];
    //QQ设置title方法为
    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:text
                                     shareImage:self.shareImg
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
}

- (void)loadData
{
    [MyHttpTool post:HomeSelectedBasePage params:@{@"id":_ID} success:^(id responseObj) {
        
        HomeSelectedModel *model = [HomeSelectedModel mj_objectWithKeyValues:responseObj[@"data"]];
        
        self.productArray = model.product;
        
        self.shareText = model.desc;
        self.shareTitle = model.title;
        self.shareUrl = model.share_url;
        // 设置headerView
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self setupHeaderView:model image:imgView.image];
            self.shareImg = imgView.image;
            
        }];
        
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        CYGLog(@"请求失败--%@", error);
    }];
}

// 设置headerView
- (void)setupHeaderView:(HomeSelectedModel *)model image:(UIImage *)image
{
    HomeSelecHeaderView *homeHeader = [HomeSelecHeaderView homeSelectedHeader];
    homeHeader.img = image;
    homeHeader.model = model;
    self.tableView.tableHeaderView = homeHeader;
}

- (UIView *)createSectionView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.x = 10;
    imageView.width = 200;
    imageView.height = 50;
    imageView.image = [UIImage imageNamed:@"ic_pimage_sticker_3_7"];
    [view addSubview:imageView];
    
    return view;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [self createSectionView];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeSeleProductModel *productModel = self.productArray[indexPath.row];
    
    CGFloat textHeight = [productModel.desc boundingRectWithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:HomeSeleTextFont} context:nil].size.height;
    
    if (productModel.pic.count == 1) {
        
        //除去nib中textlabel的高度
        return 555 + textHeight;
    }
    //俩图片 ＋280
    return 835 + textHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeSeleProductModel *produtModel = self.productArray[indexPath.row];
    if (produtModel.pic.count == 1) {
        HomeSeleCellOne *cellone = [HomeSeleCellOne cellWithTableView:tableView];
        cellone.delegate = self;
        [cellone refreshCell:produtModel index:(int)indexPath.row];
        
        //点击时不变色
        cellone.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cellone;
    }
    
    HomeSeleCellTwo *celltwo = [HomeSeleCellTwo cellWithTableView:tableView];
    celltwo.delegate = self;
    [celltwo refreshCell:produtModel index:(int)indexPath.row];
    
    //点击时不变色
    celltwo.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return celltwo;
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//TODO: this is a temporary fix to something.
    //self.tableView.tableHeaderView.height-244 先减180是上面图片的高度，图片刚刚消失使aipha是0；再减64是topview得高度，这样当section顶部刚好移到topview底部时alpha为1
    float titleViewAlpha = (self.tableView.contentOffset.y - 180)/(self.tableView.tableHeaderView.height-244);
    self.topview.alpha = titleViewAlpha;
    if (self.topview.alpha >= 1) {
        self.sectionView.hidden = NO;
    }else{
        self.sectionView.hidden = YES;
    }
    
    if (self.tableView.contentOffset.y < 0) {
        
    }
    
    
}

#pragma mark-cell代理方法
- (void)homeSeleCellOne:(HomeSeleCellOne *)cell didClickedButton:(UIButton *)button strUrl:(NSString *)strUrl
{
    HomeSeleBuyController *buyVc = [[HomeSeleBuyController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:buyVc];
    buyVc.strUrl = strUrl;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)homeSeleCellTwo:(HomeSeleCellTwo *)cell didClickedButton:(UIButton *)button strUrl:(NSString *)strUrl
{
    HomeSeleBuyController *buyVc = [[HomeSeleBuyController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:buyVc];
    buyVc.strUrl = strUrl;
    [self presentViewController:nav animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
