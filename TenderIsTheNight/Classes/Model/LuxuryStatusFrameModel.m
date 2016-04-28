

#import "LuxuryStatusFrameModel.h"
#import "LuxuryStatusModel.h"

@implementation LuxuryStatusFrameModel

- (void)setStatusModel:(LuxuryStatusModel *)statusModel
{
    _statusModel = statusModel;
    
    CGSize textSize = [statusModel.content boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:LuxuryTextFont} context:nil].size;
    CGFloat textX = 10;
    CGFloat textY = 10;
    _textLbFrame = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    _textViewFrame = CGRectMake(0, 0, ScreenWidth, textY+textSize.height + 40);
    
    _bottomViewFrame = CGRectMake(0, 0, ScreenWidth, 50);
    
    _cellHeight = 60 + ScreenWidth + _textViewFrame.size.height + _bottomViewFrame.size.height;
}

@end
