

#import <Foundation/Foundation.h>

@interface HomeEntryModel : NSObject
@property (copy, nonatomic) NSString *author_id;
@property (copy, nonatomic) NSString *datestr;
/*图片URL*/
@property (copy, nonatomic) NSString *pic1;
@property (copy, nonatomic) NSString *pic2;
@property (copy, nonatomic) NSString *share_url;
@property (copy, nonatomic) NSString *rank_share_url;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *type;
@end
