
#import <Foundation/Foundation.h>

@class LuxuryAuthor,LuxuryDynamic;
@interface LuxuryStatusModel : NSObject

@property (strong, nonatomic) LuxuryAuthor *author;

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *datestr;

@property (strong, nonatomic) LuxuryDynamic *dynamic;

@property (strong, nonatomic) NSArray *pics;

@property (copy, nonatomic) NSString *share_url;


@end
