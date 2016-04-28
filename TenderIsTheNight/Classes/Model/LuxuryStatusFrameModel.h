


#import <Foundation/Foundation.h>

@class LuxuryStatusModel;
@interface LuxuryStatusFrameModel : NSObject

@property (strong, nonatomic) LuxuryStatusModel *statusModel;

@property (assign, nonatomic) CGRect textViewFrame;
@property (assign, nonatomic) CGRect textLbFrame;
@property (assign, nonatomic) CGRect bottomViewFrame;

@property (assign, nonatomic) BOOL focusIsSelected;
@property (assign, nonatomic) BOOL likesIsSelected;

@property (assign, nonatomic) float cellHeight;

@end
