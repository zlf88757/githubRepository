
#import "HeaderView.h"
#import "UIButton+WebCache.h"
#import "HomeBannerModel.h"
#import "HomeEntryModel.h"

@interface HeaderView()<UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *bannerScro;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) UIScrollView *entryScro;

@property (weak, nonatomic) UIButton *searchBtn;
@property (weak, nonatomic) UIButton *signInBtn;

@property (weak, nonatomic) NSTimer *timer;
@end

@implementation HeaderView

+ (instancetype)homeHeader
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.height = 330;
        self.width = ScreenWidth;
        
        UIScrollView *bannerScro = [[UIScrollView alloc] init];
        bannerScro.showsHorizontalScrollIndicator = NO;
        bannerScro.showsVerticalScrollIndicator = NO;
        bannerScro.pagingEnabled = YES;
        bannerScro.delegate = self;
        [self addSubview:bannerScro];
        self.bannerScro = bannerScro;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        UIScrollView *entryScro = [[UIScrollView alloc] init];
        entryScro.showsHorizontalScrollIndicator = NO;
        entryScro.showsVerticalScrollIndicator = NO;
        //entryScro.pagingEnabled = YES;
        entryScro.delegate = self;
        [self addSubview:entryScro];
        self.entryScro = entryScro;
        
        [self setupSearchBtnAndSignInBtn];
    }
    return self;
}

- (void)setupSearchBtnAndSignInBtn
{
    
    UIButton *searchBtn = [[UIButton alloc] init];
    searchBtn.x = 8;
    searchBtn.y = 18;
    searchBtn.width = 40;
    searchBtn.height = 40;
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"ic_main_home_search_pressed"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"ic_main_home_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];
    self.searchBtn = searchBtn;
    
    
    UIButton *signInBtn = [[UIButton alloc] init];
    signInBtn.y = 18;
    signInBtn.width = 40;
    signInBtn.height = 40;
    signInBtn.x = self.width - signInBtn.width - 8;
    [signInBtn setBackgroundImage:[UIImage imageNamed:@"ic_main_home_sign_in_pressed"] forState:UIControlStateNormal];
    [signInBtn setImage:[UIImage imageNamed:@"ic_main_home_sign_in"] forState:UIControlStateNormal];
    [signInBtn addTarget:self action:@selector(signInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:signInBtn];
    self.signInBtn = signInBtn;
    
}

- (void)searchBtnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectedSearchBth:)]) {
        [self.delegate headerView:self didSelectedSearchBth:button];
    }
}

- (void)signInBtnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectedsignInBtn:)]) {
        [self.delegate headerView:self didSelectedsignInBtn:button];
    }
}


- (void)setBannerArray:(NSArray *)bannerArray
{
    _bannerArray = bannerArray;
    
    CYGLog(@"%@",_bannerArray);
    
    self.bannerScro.width = self.width;
    self.bannerScro.height = (2*self.height)/3;
    
    self.pageControl.width = self.width;
    self.pageControl.height = 30;
    self.pageControl.y = self.bannerScro.height - self.pageControl.height;
    self.pageControl.numberOfPages = self.bannerArray.count;
    
    int bannerCount = (int)self.bannerArray.count;
    CGFloat imageBtnW = self.bannerScro.width;
    CGFloat imageBtnH = self.bannerScro.height;
    int i ;
    for ( i = 0; i < bannerCount; i++) {
        UIButton *imageBtn = [[UIButton alloc]init];
        
        HomeBannerModel *bannerModel = self.bannerArray[i];
        
        [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:bannerModel.photo] forState:UIControlStateNormal];
        imageBtn.adjustsImageWhenHighlighted = NO;
        imageBtn.tag = 100 + i;
        [imageBtn addTarget:self action:@selector(bannerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.width = imageBtnW;
        imageBtn.height = imageBtnH;
        imageBtn.x = i * imageBtnW;
        [self.bannerScro addSubview:imageBtn];
    }
    
    UIButton *lastImageBtn = [[UIButton alloc]init];
    HomeBannerModel *bannerModel = self.bannerArray[0];
    [lastImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:bannerModel.photo] forState:UIControlStateNormal];
    lastImageBtn.tag = 100 + i;
    [lastImageBtn addTarget:self action:@selector(bannerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    lastImageBtn.width = imageBtnW;
    lastImageBtn.height = imageBtnH;
    lastImageBtn.x = i * imageBtnW;
    [self.bannerScro addSubview:lastImageBtn];
    
    self.bannerScro.contentSize = CGSizeMake(self.width * (self.bannerArray.count+1), 0);
}

- (void)setEntryArray:(NSArray *)entryArray
{
    _entryArray = entryArray;
    
    self.entryScro.width = self.width;
    self.entryScro.height = self.height/3;
    self.entryScro.y = self.height - self.entryScro.height;
    
    int entryCount = (int)self.entryArray.count;
    CGFloat margin = 10;
    CGFloat entryimageH = self.entryScro.height - 2*margin;
    CGFloat entryimageW = entryimageH;
    CGFloat entryimageY = margin;
    for (int i = 0; i < entryCount; i++) {
        UIButton *imageBtn = [[UIButton alloc]init];
        
        HomeEntryModel *entryModel = self.entryArray[i];
        
        [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:entryModel.pic1] forState:UIControlStateNormal];
        imageBtn.adjustsImageWhenHighlighted = NO;
        imageBtn.tag = 200 + i;
        [imageBtn addTarget:self action:@selector(entryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.width = entryimageW;
        imageBtn.height = entryimageH;
        imageBtn.x = i * (entryimageW + margin) + margin;
        imageBtn.y = entryimageY;
        
        [self.entryScro addSubview:imageBtn];
    }
    self.entryScro.contentSize = CGSizeMake((entryimageW+10) * self.entryArray.count + 10, 0);
    
    [self createTimer];
}

#pragma mark-轮播计时器
- (void)createTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
    self.timer = timer;
    
}
- (void)autoPlay
{
    if (self.pageControl.currentPage == self.bannerArray.count - 1) {
        self.pageControl.currentPage = 0;
        
        [self.bannerScro setContentOffset:CGPointMake(self.bannerScro.width*self.bannerArray.count, 0) animated:YES];
        
    }else{
        self.pageControl.currentPage++;
        [self.bannerScro setContentOffset:CGPointMake(self.bannerScro.width*self.pageControl.currentPage, 0) animated:YES];
    }
    
    
}

- (void)bannerButtonClick:(UIButton *)button
{
    CYGLog(@"buttonClick---%ld",(long)button.tag);
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectedBannerBtn:)]) {
        [self.delegate headerView:self didSelectedBannerBtn:button];
    }
}

- (void)entryButtonClick:(UIButton *)button
{
    CYGLog(@"buttonClick---%ld",(long)button.tag);
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectedEntryBtn:)]) {
        [self.delegate headerView:self didSelectedEntryBtn:button];
    }
    
}

#pragma mark - UIScrollViewDelegate

//这个方法是不管手动托还是代码设置 都会调用，而且时连续的。慎用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //CYGLog(@"scrollViewDidScroll");
    
    if (self.bannerScro.contentOffset.x/self.bannerScro.width == self.bannerArray.count){
        
        [self.bannerScro setContentOffset:CGPointZero animated:NO];
        self.pageControl.currentPage = 0;
    }
}


//手动 图片的减速结束后执行，也就是说图片彻底停后才调这个方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.entryScro) {
        return;
    }
    
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
    if (self.bannerScro.contentOffset.x/self.bannerScro.width == self.bannerArray.count){
        
        [self.bannerScro setContentOffset:CGPointZero animated:NO];
        self.pageControl.currentPage = 0;
    }
    
}

//手动托不会调用这个方法，只有在动画使这个图片滚动结束后才会调用，比如代码设置scrollview的坐标
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.bannerScro.contentOffset.x/self.bannerScro.width == self.bannerArray.count){
        [self.bannerScro setContentOffset:CGPointZero animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self createTimer];
}
@end











