

#import <Foundation/Foundation.h>

@interface HomeTopicModel : NSObject
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *pic;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *likes;

@property (assign, nonatomic) BOOL isSelected;

@end
