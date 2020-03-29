
#import <Foundation/Foundation.h>
#import "HPAudioFrame.h"
#import "HPVideoFrame.h"


/** current buffer status */
typedef NS_ENUM (NSUInteger, HPLiveBuffferState) {
    HPLiveBuffferStateUnknown = 0,      // 未知
    HPLiveBuffferStateIncrease = 1,    // 缓冲区状态差应该降低码率
    HPLiveBuffferStateDecline = 2      // 缓冲区状态好应该提升码率
};

@class HPStreamingBuffer;
/** this two method will control videoBitRate */
@protocol HPStreamingBufferDelegate <NSObject>
@optional
/** 当前buffer变动（增加or减少） 根据buffer中的updateInterval时间回调*/
- (void)streamingBuffer:(nullable HPStreamingBuffer *)buffer bufferState:(HPLiveBuffferState)state;
@end

@interface HPStreamingBuffer : NSObject


/** The delegate of the buffer. buffer callback */
@property (nullable, nonatomic, weak) id <HPStreamingBufferDelegate> delegate;

/** current frame buffer */
@property (nonatomic, strong, readonly) NSMutableArray <HPFrame *> *_Nonnull list;

/** buffer count max size default 1000 */
@property (nonatomic, assign) NSUInteger maxCount;

/** count of drop frames in last time */
@property (nonatomic, assign) NSInteger lastDropFrames;

/** add frame to buffer */
- (void)appendObject:(nullable HPFrame *)frame;

/** pop the first frome buffer */
- (nullable HPFrame *)popFirstObject;

/** remove all objects from Buffer */
- (void)removeAllObject;

@end
