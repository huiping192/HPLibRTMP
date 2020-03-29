#import <Foundation/Foundation.h>
#import "HPLiveStreamInfo.h"
#import "HPStreamingBuffer.h"
#import "HPLiveDebug.h"


@protocol HPStreamSocket;
@protocol HPStreamSocketDelegate <NSObject>

/** callback buffer current status (回调当前缓冲区情况，可实现相关切换帧率 码率等策略)*/
- (void)socketBufferStatus:(id <HPStreamSocket> _Nonnull)socket status:(HPLiveBuffferState)status;
/** callback socket current status (回调当前网络情况) */
- (void)socketStatus:(id <HPStreamSocket> _Nonnull)socket status:(HPLiveState)status;
/** callback socket errorcode */
- (void)socketDidError:(id <HPStreamSocket> _Nonnull)socket errorCode:(HPLiveSocketErrorCode)errorCode;
@optional
/** callback debugInfo */
- (void)socketDebug:(id <HPStreamSocket> _Nonnull)socket debugInfo:(HPLiveDebug * _Nonnull)debugInfo;
@end

@protocol HPStreamSocket <NSObject>
- (void)start;
- (void)stop;
- (void)sendFrame:(HPFrame * _Nonnull)frame;
- (void)setDelegate:(nullable id <HPStreamSocketDelegate>)delegate;
@optional
- (instancetype _Nonnull)initWithStream:(HPLiveStreamInfo * _Nonnull)stream;
- (instancetype _Nonnull)initWithStream:(HPLiveStreamInfo * _Nonnull)stream reconnectInterval:(NSInteger)reconnectInterval reconnectCount:(NSInteger)reconnectCount;
@end
