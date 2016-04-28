
#import "HomeCell.h"
#import "HomeTopicModel.h"
#import "UIImageView+WebCache.h"

@interface HomeCell ()

@property (weak, nonatomic) UIImageView *picView;
@property (weak, nonatomic) UIButton *titleBtn;
@property (weak, nonatomic) UIButton *likesBtn;



@end

@implementation HomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 180)];
        [self.contentView addSubview:picView];
        self.picView = picView;
        UIImageView *newimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 16)];
        newimage.image = [UIImage imageNamed:@"ic_main_home_topic_new"];
        [picView addSubview:newimage];
        self.newimage = newimage;
        
        
        
        
        UIButton *titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.picView.height, self.width, 40)];
        titleBtn.userInteractionEnabled = NO;
        titleBtn.titleLabel.font = HomeTitleFont;
        [titleBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:titleBtn];
        self.titleBtn = titleBtn;
        
        UIButton *likesBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.picView.height+self.titleBtn.height, self.width, 20)];
        likesBtn.userInteractionEnabled = NO;
        [likesBtn setImage:[UIImage imageNamed:@"ic_community_like"] forState:UIControlStateNormal];
        [likesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        likesBtn.titleLabel.font = HomeLikesFont;
        likesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [likesBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        // 设置按钮的内容居中
//        likesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.contentView addSubview:likesBtn];
        self.likesBtn = likesBtn;
    }
    return self;
}

- (void)setTopicModel:(HomeTopicModel *)topicModel
{
    _topicModel = topicModel;
    
    self.newimage.hidden = topicModel.isSelected;
    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:topicModel.pic] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    [self.titleBtn setTitle:topicModel.title forState:UIControlStateNormal];
    
    [self.likesBtn setTitle:topicModel.likes forState:UIControlStateNormal];
}


@end








