

#import "LikeMessageCell.h"

@implementation LikeMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LikeMessageCell";
    LikeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LikeMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];;
    }
    
    return cell;
}



@end
