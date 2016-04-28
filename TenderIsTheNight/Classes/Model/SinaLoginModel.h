

#import <Foundation/Foundation.h>

@interface SinaLoginModel : NSObject
@property (copy, nonatomic) NSString *access_token;

@property (copy, nonatomic) NSString *profile_image_url;

@property (copy, nonatomic) NSString *screen_name;

@property (copy, nonatomic) NSString *uid;
@end
