
#import "HPLiveDebug.h"

@implementation HPLiveDebug

- (NSString *)description {
    return [NSString stringWithFormat:@"丢掉的帧数:%ld 总帧数:%ld 上次的音频捕获个数:%ld 上次的视频捕获个数:%ld 未发送个数:%ld 总流量:%0.f",_dropFrame,_totalFrame,_currentCapturedAudioCount,_currentCapturedVideoCount,_unSendCount,_dataFlow];
}


@end
