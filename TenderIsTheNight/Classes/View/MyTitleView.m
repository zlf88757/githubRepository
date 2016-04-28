

#import "MyTitleView.h"

@implementation MyTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
//        [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        //self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        //self.height = self.currentImage.size.height;
        self.height = 35;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    [self setTitle:title forState:UIControlStateNormal];
    
    NSDictionary *attrs = @{NSFontAttributeName:self.titleLabel.font};
    CGFloat titleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
    
//    self.width = titleW + self.titleEdgeInsets.left + self.currentImage.size.width;
    self.width = titleW;
}

@end
