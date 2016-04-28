

#import "LikeHotCell.h"
#import "UIImageView+WebCache.h"

@interface LikeHotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *hotImage;


@end

@implementation LikeHotCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LikeHotCell";
    LikeHotCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LikeHotCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)setPhotoUrl:(NSString *)photoUrl
{
    _photoUrl = photoUrl;
    
    [self.hotImage sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
}

@end
