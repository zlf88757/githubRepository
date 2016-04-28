

#import <Foundation/Foundation.h>

@interface HomeSeleProductModel : NSObject

@property (copy, nonatomic) NSString *comments;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *id;
@property (assign, nonatomic) BOOL iscomments;
@property (assign, nonatomic) BOOL islike;
@property (copy, nonatomic) NSString *item_id;
@property (copy, nonatomic) NSString *likes;
@property (strong, nonatomic) NSArray *likes_list;
@property (strong, nonatomic) NSArray *pic;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *title;
/*webView 淘宝*/
@property (copy, nonatomic) NSString *url;

@end
