
#import "HomeSeleCellTwo.h"
#import "HomeSeleProductModel.h"
#import "HomeSeleLikesiconModel.h"
#import "HomeSelePicModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface HomeSeleCellTwo ()
@property (weak, nonatomic) IBOutlet UIImageView *numImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *textLb;
@property (weak, nonatomic) IBOutlet UIImageView *picViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *picViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *likesLb;
@property (weak, nonatomic) IBOutlet UIButton *likeListBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIView *like_listsView;

@property (strong, nonatomic) HomeSeleProductModel *model;

@end

@implementation HomeSeleCellTwo

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeSeleCellTwo";
    HomeSeleCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeSeleCellTwo" owner:nil options:nil]lastObject];
    }
    return cell;
}
- (void)refreshCell:(HomeSeleProductModel *)model index:(int)index
{
    _model = model;
    
    NSString *imgName = [NSString stringWithFormat:@"ind%.2d",index + 1];
    self.numImg.image = [UIImage imageNamed:imgName];
    
    self.titleLb.text = model.title;
    self.textLb.text = model.desc;
    
    HomeSelePicModel *picModelOne = model.pic[0];
    HomeSelePicModel *picModelTwo = model.pic[1];
    NSString *picUrlOne = [NSString stringWithFormat:@"%@%@",ProductPicBasePage,picModelOne.p];
    NSString *picUrlTwo = [NSString stringWithFormat:@"%@%@",ProductPicBasePage,picModelTwo.p];
    [self.picViewOne sd_setImageWithURL:[NSURL URLWithString:picUrlOne] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self.picViewTwo sd_setImageWithURL:[NSURL URLWithString:picUrlTwo] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    if (model.likes_list.count >= 7) {
        for (int i = 0; i < 7; i++) {
            HomeSeleLikesiconModel *likesModel = model.likes_list[i];
            NSString *iconUrl = [NSString stringWithFormat:@"%@%@?u=%@",ProductLikeIconBasePage,likesModel.a,likesModel.u];
            UIButton *iconBtn = (UIButton *)[self.like_listsView viewWithTag:(2000 + i)];
            iconBtn.layer.cornerRadius = iconBtn.width/2;
            iconBtn.layer.masksToBounds = YES;
            [iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_default_avatar_circle"]];
        }
    }
    
    self.priceLb.text = [NSString stringWithFormat:@"参考价：￥%@",model.price];
    self.likesLb.text = [NSString stringWithFormat:@"%@人喜欢",model.likes];
    
    [self.commentBtn setTitle:model.comments forState:UIControlStateNormal];
    [self.likesBtn setTitle:model.likes forState:UIControlStateNormal];
    
}
- (IBAction)buyBtnClick {
    if ([self.delegate respondsToSelector:@selector(homeSeleCellTwo:didClickedButton:strUrl:)]) {
        [self.delegate homeSeleCellTwo:self didClickedButton:self.buyBtn strUrl:_model.url];
    }
}

@end
