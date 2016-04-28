

#import "BottomBar.h"
#import "BottomBarButton.h"

@interface BottomBar()
@property (weak, nonatomic) BottomBarButton *selectedButton;
@end

@implementation BottomBar
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage resizedImage:@"tabbar_background@2x"]];
        
        BottomBarButton *homeBtn = [self setupBtnWithIcon:@"main_tab_home" selectedIcon:@"main_tab_home_checked"];
        homeBtn.tag = 0;
        
        BottomBarButton *luxuryBtn = [self setupBtnWithIcon:@"ic_main_tab_community" selectedIcon:@"ic_main_tab_community_checked"];
        luxuryBtn.tag = 1;
        
        BottomBarButton *btn = [[BottomBarButton alloc] init];
        [btn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"ic_main_tab_publish_pressed"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_main_tab_publish_pressed"] forState:UIControlStateSelected];
        btn.contentMode = UIViewContentModeCenter;
        btn.adjustsImageWhenHighlighted = NO;
        
        
        BottomBarButton *likeBtn =[self setupBtnWithIcon:@"ic_main_tab_msg" selectedIcon:@"ic_main_tab_msg_checked"];
        likeBtn.tag = 2;
        
        BottomBarButton *personBtn = [self setupBtnWithIcon:@"ic_main_tab_personal" selectedIcon:@"ic_main_tab_personal_checked"];
        personBtn.tag = 3;
        
    }
    
    return self;
}

- (void)setDelegate:(id<BottomBarDelegate>)delegate
{
    _delegate = delegate;
    
    [self btnClick:[self.subviews firstObject]];
}

/**
 *  添加按钮
 */
- (BottomBarButton *)setupBtnWithIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon
{
    BottomBarButton *btn = [[BottomBarButton alloc] init];
    //btn.tag = self.subviews.count;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    //这里设置TouchDown是希望点一下button就会变色，如果是TouchUpInside不会变色
    [self addSubview:btn];
    
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    //内容居中
    btn.contentMode = UIViewContentModeCenter;
    // 设置高亮的时候不要让图标变色
    btn.adjustsImageWhenHighlighted = NO;
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    int btnCount = (int)self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    int i;
    for ( i = 0; i < btnCount - 1; i++) {
        BottomBarButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
    }
    
    BottomBarButton *btn = [self.subviews lastObject];
    btn.y = 5;
    btn.height = self.height - 2 * btn.y;
    btn.width = btn.height;
    btn.x = i *btnW + 10;
    
    
}

- (void)btnClick:(BottomBarButton *)button
{
    CYGLog(@"btnClick");
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(bottomBar:didSelectedButtonFromIndex:toIndex:)]) {
        [self.delegate bottomBar:self didSelectedButtonFromIndex:(int)self.selectedButton.tag toIndex:(int)button.tag];
    }
    
    // 控制按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)plusBtnClick:(BottomBarButton *)button
{
    if ([self.plusBtnDelegate respondsToSelector:@selector(bottomBar:didSelectedPlusButton:)]) {
        [self.plusBtnDelegate bottomBar:self didSelectedPlusButton:button];
    }
}

@end
