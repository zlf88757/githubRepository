

#import "LuxuryCell.h"
#import "LuxuryStatusFrameModel.h"
#import "LuxuryStatusModel.h"
#import "UIImageView+WebCache.h"
#import "LuxuryAuthor.h"
#import "Photo.h"
#import "LuxuryDynamic.h"


@interface LuxuryCell ()
/*cell顶部*/
@property (weak, nonatomic) UIImageView *topView;
//头像
@property (weak, nonatomic) UIImageView *iconView;
@property (weak, nonatomic) UILabel *nameLb;
@property (weak, nonatomic) UILabel *timeLb;
@property (weak, nonatomic) UIImageView *vipView;
@property (weak, nonatomic) UIButton *focusBtn;

/*cell中间大图*/
@property (weak, nonatomic) UIImageView *picView;

/*cell文字和标签部分*/
@property (weak, nonatomic) UIImageView *textView;
@property (weak, nonatomic) UILabel *textLb;
@property (weak, nonatomic) UIImageView *tagView;

/*cell底部bar*/
@property (weak, nonatomic) UIImageView *bottomView;
@property (weak, nonatomic) UIButton *shareBtn;
@property (weak, nonatomic) UIButton *likeBtn;
@property (weak, nonatomic) UIButton *buyBtn;

@end

@implementation LuxuryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeCell";
    LuxuryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LuxuryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.width = ScreenWidth;
  //topView
        UIImageView *topView = [[UIImageView alloc]init];
        topView.image = [UIImage imageWithColor:[UIColor whiteColor]];
        topView.userInteractionEnabled = YES;
        topView.height = 60;
        topView.width = ScreenWidth;
        [self.contentView addSubview:topView];
        self.topView = topView;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.x = 10;
        iconView.y = 15;
        iconView.width = 30;
        iconView.height = 30;
        iconView.layer.cornerRadius = 15;
        iconView.layer.masksToBounds = YES;
        iconView.backgroundColor = [UIColor orangeColor];
        [topView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *nameLb = [[UILabel alloc]init];
        nameLb.x = CGRectGetMaxX(iconView.frame) + 10;
        nameLb.y = iconView.y;
        nameLb.width = 200;
        nameLb.height = 15;
        nameLb.textColor = [UIColor grayColor];
        nameLb.font = [UIFont systemFontOfSize:13];
        [topView addSubview:nameLb];
        self.nameLb = nameLb;
        
        UILabel *timeLb = [[UILabel alloc]init];
        timeLb.x = CGRectGetMaxX(iconView.frame) + 10;
        timeLb.y = CGRectGetMaxY(nameLb.frame) + 5;
        timeLb.width = 150;
        timeLb.height = 10;
        timeLb.textColor = [UIColor lightGrayColor];
        timeLb.font = [UIFont systemFontOfSize:11];
        [topView addSubview:timeLb];
        self.timeLb = timeLb;
        
        
        UIImageView *vipView = [[UIImageView alloc]init];
        vipView.x = ScreenWidth - 100;
        vipView.y = 20;
        vipView.width = 20;
        vipView.height = 20;
        vipView.layer.cornerRadius = 10;
        vipView.image = [UIImage imageNamed:@"ic_communit_edit_choice"];
        [topView addSubview:vipView];
        self.vipView = vipView;
        
        UIButton *focusBtn = [[UIButton alloc] init];
        focusBtn.x = CGRectGetMaxX(vipView.frame) + 10;
        focusBtn.y = vipView.y;
        focusBtn.width = 60;
        focusBtn.height = 20;
        [focusBtn addTarget:self action:@selector(focusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [focusBtn setImage:[UIImage imageNamed:@"ic_normal_follow"] forState:UIControlStateNormal];
        [focusBtn setImage:[UIImage imageNamed:@"ic_normal_followed"] forState:UIControlStateSelected];
        [topView addSubview:focusBtn];
        self.focusBtn = focusBtn;
        
        
     //picView
        UIImageView *picView = [[UIImageView alloc] init];
        picView.y = topView.height;
        picView.width = ScreenWidth;
        picView.height = picView.width;
        [self.contentView addSubview:picView];
        self.picView = picView;
        
      //textView
        UIImageView *textView = [[UIImageView alloc] init];
        textView.image = [UIImage imageWithColor:[UIColor whiteColor]];
        [self.contentView addSubview:textView];
        self.textView = textView;
        
        UILabel *textLb = [[UILabel alloc] init];
        textLb.numberOfLines = 0;
        textLb.font = LuxuryTextFont;
        textLb.textColor = [UIColor grayColor];
        [textView addSubview:textLb];
        self.textLb = textLb;
        
        UIImageView *tagView = [[UIImageView alloc] init];
        [textView addSubview:tagView];
        tagView.image = [UIImage imageNamed:@"ic_pimage_goods_focused"];
        self.tagView = tagView;
        
        //bottomView
        UIImageView *bottomView = [[UIImageView alloc]init];
        bottomView.userInteractionEnabled = YES;
        bottomView.image = [UIImage imageNamed:@"bg_topic_product_split.9"];
        [self.contentView addSubview:bottomView];
        self.bottomView = bottomView;
        
        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.tag = LuxuryCellButtonTypeShare;
        [shareBtn setImage:[UIImage imageNamed:@"UMS_share_normal_white"] forState:UIControlStateNormal];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:shareBtn];
        self.shareBtn = shareBtn;
        
        UIButton *likeBtn = [[UIButton alloc] init];
        likeBtn.tag = LuxuryCellButtonTypeLike;
        [likeBtn setImage:[UIImage imageNamed:@"ic_community_like"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"ic_common_double_column_list_like_checked"] forState:UIControlStateSelected];
        likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:likeBtn];
        self.likeBtn = likeBtn;
        
        UIButton *buyBtn = [[UIButton alloc] init];
        buyBtn.tag = LuxuryCellButtonTypeBuy;
        [buyBtn setImage:[UIImage imageNamed:@"ic_main_product_cart"] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        buyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:buyBtn];
        self.buyBtn = buyBtn;
    }
    return self;
}

- (void)setFrameModel:(LuxuryStatusFrameModel *)frameModel
{
    _frameModel = frameModel;
    
    LuxuryStatusModel *model = frameModel.statusModel;
    
    LuxuryAuthor *author = model.author;
    
    LuxuryDynamic *dynamic = model.dynamic;
    
    //获得focusBtn的选中状态 因为点了关注还要发请求告诉服务器，所以这里先不用数据中的is_collect
    //self.focusBtn.selected = dynamic.is_collect;
    self.focusBtn.selected = frameModel.focusIsSelected;
    //获得likeBtn的选中状态
    self.likeBtn.selected = frameModel.likesIsSelected;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:author.avatar] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    self.nameLb.text = author.username;
    
    self.timeLb.text = model.datestr;
    
    
    NSArray *pics = model.pics;
    Photo *photo = [pics firstObject];
    [self.picView sd_setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    self.textView.frame = frameModel.textViewFrame;
    self.textView.y = CGRectGetMaxY(self.picView.frame);
    
    self.textLb.text = model.content;
    self.textLb.frame = frameModel.textLbFrame;
    
    self.tagView.frame = CGRectMake(self.textLb.x, CGRectGetMaxY(self.textLb.frame)+20, 10, 10);
    
    self.bottomView.frame = frameModel.bottomViewFrame;
    self.bottomView.y = CGRectGetMaxY(self.textView.frame);
    
   
    if (self.likeBtn.selected == YES) {
         NSString *likes = [NSString stringWithFormat:@"%d",dynamic.likes+1];
        [self.likeBtn setTitle:likes forState:UIControlStateNormal];
    }else{
        NSString *likes = [NSString stringWithFormat:@"%d",dynamic.likes];
        [self.likeBtn setTitle:likes forState:UIControlStateNormal];
    }
    
    
    self.shareBtn.frame = CGRectMake(0, 0, ScreenWidth/3, self.bottomView.height);
    self.likeBtn.frame = CGRectMake(self.shareBtn.width, 0, ScreenWidth/3, self.bottomView.height);
    self.buyBtn.frame = CGRectMake(self.shareBtn.width+self.likeBtn.width, 0, ScreenWidth/3, self.bottomView.height);
}



#pragma mark-buttonClick
- (void)focusBtnClick:(UIButton *)button
{
    CYGLog(@"focusBtnClick");
    //点击后用block回调改变数据源中对应下标模型的bool值
    
    //因为点了关注还要发请求告诉服务器，所以这里先不用数据中的is_collect
    
    button.selected = !button.selected;
    _myblock(self.index,button.selected);
}
- (void)shareBtnClick:(UIButton *)button
{
    CYGLog(@"shareBtnClick");
    
    UIImage *image = self.picView.image;
    NSString *text = self.textLb.text;
    
    LuxuryStatusModel *model = self.frameModel.statusModel;
    NSString *url = model.share_url;
    
    NSDictionary *info = @{@"image":image,@"text":text,@"url":url};
    
    if ([self.delegate respondsToSelector:@selector(luxuryCell:didClickedButton:info:)]) {
        [self.delegate luxuryCell:self didClickedButton:(LuxuryCellButtonType)button.tag info:info];
    }
    
    
}
- (void)likeBtnClick:(UIButton *)button
{
    CYGLog(@"likeBtnClick");
    button.selected = !button.selected;
    _likesBlock(self.index,button.selected);
    
    
    LuxuryStatusModel *model = _frameModel.statusModel;
    
    LuxuryDynamic *dynamic = model.dynamic;
    
    if (self.likeBtn.selected == YES) {
        NSString *likes = [NSString stringWithFormat:@"%d",dynamic.likes+1];
        [self.likeBtn setTitle:likes forState:UIControlStateNormal];
    }else{
        NSString *likes = [NSString stringWithFormat:@"%d",dynamic.likes];
        [self.likeBtn setTitle:likes forState:UIControlStateNormal];
    }

}
- (void)buyBtnClick:(UIButton *)button
{
    CYGLog(@"buyBtnClick");
}
@end

















