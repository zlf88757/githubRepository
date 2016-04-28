

#import <Foundation/Foundation.h>

@interface HomeSelectedModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *desc;

@property (copy, nonatomic) NSString *pic;

@property (strong, nonatomic) NSArray *product;

@property (copy, nonatomic) NSString *share_url;

@end
