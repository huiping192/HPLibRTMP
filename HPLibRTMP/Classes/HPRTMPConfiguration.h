#import <Foundation/Foundation.h>

@interface HPRTMPConfiguration : NSObject

#pragma mark -- RTMP URL
 /// 上传地址
@property (nonatomic, copy) NSString *url;

///音频配置
@property (nonatomic, assign) CGFloat audioBitrate;
@property (nonatomic, assign) CGFloat audioSampleRate;
@property (nonatomic, assign) int numberOfChannels;

///视频配置
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) CGFloat videoBitrate;
@property (nonatomic, assign) CGFloat videoFrameRate;

@end
