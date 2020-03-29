#import <Foundation/Foundation.h>

/// 流状态
typedef NS_ENUM (NSUInteger, HPLiveState){
    /// 准备
    HPLiveStateReady = 0,
    /// 连接中
    HPLiveStatePending = 1,
    /// 已连接
    HPLiveStateStart = 2,
    /// 已断开
    HPLiveStateStop = 3,
    /// 连接出错
    HPLiveStateError = 4,
    ///  正在刷新
    HPLiveStateRefresh = 5
};

typedef NS_ENUM (NSUInteger, HPLiveSocketErrorCode) {
    HPLiveSocketErrorCodePreView = 201,              ///< 预览失败
    HPLiveSocketErrorCodeGetStreamInfo = 202,        ///< 获取流媒体信息失败
    HPLiveSocketErrorCodeConnectSocket = 203,        ///< 连接socket失败
    HPLiveSocketErrorCodeVerification = 204,         ///< 验证服务器失败
    HPLiveSocketErrorCodeReConnectTimeOut = 205      ///< 重新连接服务器超时
};

@interface HPLiveStreamInfo : NSObject

@property (nonatomic, copy) NSString *streamId;

#pragma mark -- RTMP URL
@property (nonatomic, copy) NSString *url;          ///< 上传地址 (RTMP用就好了)
///音频配置
@property (nonatomic, assign) CGFloat audioBitrate;
@property (nonatomic, assign) CGFloat audioSampleRate;
@property (nonatomic, assign) int numberOfChannels;

///视频配置
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) CGFloat videoBitrate;
@property (nonatomic, assign) CGFloat videoFrameRate;

@end
