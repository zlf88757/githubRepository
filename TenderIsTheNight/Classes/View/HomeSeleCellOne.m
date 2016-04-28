
#import "HomeSeleCellOne.h"
#import "HomeSeleProductModel.h"
#import "HomeSelePicModel.h"
#import "HomeSeleLikesiconModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface HomeSeleCellOne ()
@property (weak, nonatomic) IBOutlet UIImageView *numImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *textLb;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *likesLb;
@property (weak, nonatomic) IBOutlet UIButton *likeListBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIView *like_listsView;

@property (strong, nonatomic) HomeSeleProductModel *model;

@end

@implementation HomeSeleCellOne

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeSeleCellOne";
    HomeSeleCellOne *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeSeleCellOne" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)refreshCell:(HomeSeleProductModel *)model index:(int)index
{
    _model = model;
    
    NSString *imgName = [NSString stringWithFormat:@"ind%.2d",index];
    self.numImg.image = [UIImage imageNamed:imgName];
    
    self.titleLb.text = model.title;
    self.textLb.text = model.desc;
    
    HomeSelePicModel *picModel = [model.pic firstObject];
    NSString *picUrl = [NSString stringWithFormat:@"%@%@",ProductPicBasePage,picModel.p];
    [self.picView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    if (model.likes_list.count >= 7) {
        for (int i = 0; i < 7; i++) {
            HomeSeleLikesiconModel *likesModel = model.likes_list[i];
            NSString *iconUrl = [NSString stringWithFormat:@"%@%@?u=%@",ProductLikeIconBasePage,likesModel.a,likesModel.u];
            UIButton *iconBtn = (UIButton *)[self.like_listsView viewWithTag:(1000 + i)];
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
    if ([self.delegate respondsToSelector:@selector(homeSeleCellOne:didClickedButton:strUrl:)]) {
        [self.delegate homeSeleCellOne:self didClickedButton:self.buyBtn strUrl:_model.url];
    }
}

@end
















