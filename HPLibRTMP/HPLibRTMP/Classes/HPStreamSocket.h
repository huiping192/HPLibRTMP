#import <Foundation/Foundation.h>
#import "HPLiveStreamInfo.h"
#import "HPStreamingBuffer.h"
#import "HPLiveDebug.h"


@protocol HPStreamSocket;
@protocol HPStreamSocketDelegate <NSObject>

/** callback buffer current status (回调当前缓冲区情况，可实现相关切换帧率 码率等策略)*/
- (void)socketBufferStatus:(nullable id <HPStreamSocket>)socket status:(HPLiveBuffferState)status;
/** callback socket current status (回调当前网络情况) */
- (void)socketStatus:(nullable id <HPStreamSocket>)socket status:(HPLiveState)status;
/** callback socket errorcode */
- (void)socketDidError:(nullable id <HPStreamSocket>)socket errorCode:(HPLiveSocketErrorCode)errorCode;
@optional
/** callback debugInfo */
- (void)socketDebug:(nullable id <HPStreamSocket>)socket debugInfo:(nullable HPLiveDebug *)debugInfo;
@end

@protocol HPStreamSocket <NSObject>
- (void)start;
- (void)stop;
- (void)sendFrame:(nullable HPFrame *)frame;
- (void)setDelegate:(nullable id <HPStreamSocketDelegate>)delegate;
@optional
- (instancetype _Nonnull)initWithStream:(HPLiveStreamInfo * _Nonnull)stream;
- (instancetype _Nonnull)initWithStream:(HPLiveStreamInfo * _Nonnull)stream reconnectInterval:(NSInteger)reconnectInterval reconnectCount:(NSInteger)reconnectCount;
@end
