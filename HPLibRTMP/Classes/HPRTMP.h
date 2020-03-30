//
//  HPRTMP.h
//  HPLibRTMP
//
//  Created by Huiping Guo on 2020/03/30.
//

#import <Foundation/Foundation.h>
#import "HPRTMPConf.h"

@class HPRTMP;
@protocol HPRTMPDelegate <NSObject>
@optional
- (void)rtmp:(HPRTMP *)rtmp error:(NSError *)error;
@end


@interface HPRTMP : NSObject

@property (nonatomic, weak) id<HPRTMPDelegate> delegate;

-(HPRTMP *)initWithConf:(HPRTMPConf *)conf;

- (NSInteger)connect;
-(void)close;

- (void)sendVideoHeaderWithSPS:(NSData *)spsData pps:(NSData *)ppsData;
- (void)sendVideoWithVideoData:(NSData *)frameData timestamp:(uint64_t)timestamp isKeyFrame:(BOOL)isKeyFrame;

- (void)sendAudioHeader:(NSData *)header;
- (void)sendAudioWithAudioData:(NSData *)audioData timestamp:(uint64_t)timestamp;

@end
