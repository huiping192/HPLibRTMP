
#import "HPFrame.h"

@interface HPVideoFrame : HPFrame

@property (nonatomic, assign) BOOL isKeyFrame;

@property (nonatomic, strong) NSData *sps;
@property (nonatomic, strong) NSData *pps;

@end
