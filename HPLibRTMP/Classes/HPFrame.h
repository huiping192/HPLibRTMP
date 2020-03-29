#import <Foundation/Foundation.h>

@interface HPFrame : NSObject

@property (nonatomic, assign,) uint64_t timestamp;
@property (nonatomic, strong) NSData *data;

@end
