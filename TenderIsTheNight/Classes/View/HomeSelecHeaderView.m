
#import "HomeSelecHeaderView.h"
#import "HomeSelectedModel.h"

@interface HomeSelecHeaderView ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *titleLb;
@property (weak, nonatomic) UILabel *textLb;

@end

@implementation HomeSelecHeaderView


+ (instancetype)homeSelectedHeader
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel * titleLb = [[UILabel alloc] init];
        titleLb.font = HomeSeleTitleFont;
        titleLb.textColor = [UIColor grayColor];
        [self addSubview:titleLb];
        self.titleLb = titleLb;
        
        UILabel *textLb = [[UILabel alloc] init];
        textLb.font = HomeSeleTextFont;
        textLb.textColor = titleLb.textColor;
        textLb.numberOfLines = 0;
        [self addSubview:textLb];
        self.textLb = textLb;
    
    }
    return self;
}

- (void)setModel:(HomeSelectedModel *)model
{
    _model = model;
    
    self.imageView.image = _img;
    
    self.titleLb.text = model.title;
    self.textLb.text = model.desc;
    
    self.imageView.width = ScreenWidth;
    self.imageView.height = 180;
    
    self.titleLb.x = 10;
    self.titleLb.y = self.imageView.height + 20;
    self.titleLb.width = ScreenWidth - 2 * self.titleLb.x;
    self.titleLb.height = 20;
    
    self.textLb.x = self.titleLb.x;
    self.textLb.y = CGRectGetMaxY(self.titleLb.frame) + 20;
    self.textLb.width = self.titleLb.width;
    [self.textLb sizeToFit];
    
    self.width = ScreenWidth;
    self.height = CGRectGetMaxY(self.textLb.frame) + 30;
}

@end
