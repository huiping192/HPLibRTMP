//
//  HPRTMP.m
//  HPLibRTMP
//
//  Created by Huiping Guo on 2020/03/30.
//

#import "HPRTMP.h"
#import <pili_librtmp/rtmp.h>

#define RTMP_RECEIVE_TIMEOUT    2

#define SAVC(x)    static const PILI_AVal av_ ## x = AVC(#x)

static const PILI_AVal av_setDataFrame = AVC("@setDataFrame");
static const PILI_AVal av_SDKVersion = AVC("HPRTMP 0.1.0");
SAVC(onMetaData);
SAVC(duration);
SAVC(width);
SAVC(height);
SAVC(videocodecid);
SAVC(videodatarate);
SAVC(framerate);
SAVC(audiocodecid);
SAVC(audiodatarate);
SAVC(audiosamplerate);
SAVC(audiosamplesize);
SAVC(stereo);
SAVC(encoder);
SAVC(fileSize);
SAVC(avc1);
SAVC(mp4a);


@interface HPRTMP()

@property (nonatomic) PILI_RTMP *rtmp;

@property (nonatomic, assign) RTMPError error;

@property (nonatomic, strong) HPRTMPConf *conf;

@end

@implementation HPRTMP

-(HPRTMP *)initWithConf:(HPRTMPConf *)conf {
    if (self = [super init]) {
       self.conf = conf;
    }
    return self;
}

-(void)close {
    if (_rtmp != NULL) {
        PILI_RTMP_Close(_rtmp, &_error);
        PILI_RTMP_Free(_rtmp);
        _rtmp = NULL;
    }
}


- (NSInteger)connect {
    char *push_url = (char *)[self.conf.url cStringUsingEncoding:NSASCIIStringEncoding];
    //由于摄像头的timestamp是一直在累加，需要每次得到相对时间戳
    //分配与初始化
    _rtmp = PILI_RTMP_Alloc();
    PILI_RTMP_Init(_rtmp);

    //设置URL
    if (PILI_RTMP_SetupURL(_rtmp, push_url, &_error) == FALSE) {
        //log(LOG_ERR, "RTMP_SetupURL() failed!");
        goto Failed;
    }

    _rtmp->m_errorCallback = RTMPErrorCallback;
    _rtmp->m_connCallback = ConnectionTimeCallback;
    _rtmp->m_userData = (__bridge void *)self;
    _rtmp->m_msgCounter = 1;
    _rtmp->Link.timeout = RTMP_RECEIVE_TIMEOUT;
    
    //设置可写，即发布流，这个函数必须在连接前使用，否则无效
    PILI_RTMP_EnableWrite(_rtmp);

    //连接服务器
    if (PILI_RTMP_Connect(_rtmp, NULL, &_error) == FALSE) {
        goto Failed;
    }

    //连接流
    if (PILI_RTMP_ConnectStream(_rtmp, 0, &_error) == FALSE) {
        goto Failed;
    }

    [self sendMetaData];

    return 0;

Failed:
    [self close];
    return -1;
}


#pragma mark -- Rtmp Send

- (void)sendMetaData {
    PILI_RTMPPacket packet;

    char pbuf[2048], *pend = pbuf + sizeof(pbuf);

    packet.m_nChannel = 0x03;                   // control channel (invoke)
    packet.m_headerType = RTMP_PACKET_SIZE_LARGE;
    packet.m_packetType = RTMP_PACKET_TYPE_INFO;
    packet.m_nTimeStamp = 0;
    packet.m_nInfoField2 = _rtmp->m_stream_id;
    packet.m_hasAbsTimestamp = TRUE;
    packet.m_body = pbuf + RTMP_MAX_HEADER_SIZE;

    char *enc = packet.m_body;
    enc = PILI_AMF_EncodeString(enc, pend, &av_setDataFrame);
    enc = PILI_AMF_EncodeString(enc, pend, &av_onMetaData);

    *enc++ = PILI_AMF_OBJECT;

    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_duration, 0.0);
    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_fileSize, 0.0);

    // videosize
    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_width, self.conf.videoSize.width);
    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_height, self.conf.videoSize.height);

    // video
    enc = PILI_AMF_EncodeNamedString(enc, pend, &av_videocodecid, &av_avc1);

    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_videodatarate, self.conf.videoBitrate / 1000.f);
    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_framerate, self.conf.videoFrameRate);

    // audio
    enc = PILI_AMF_EncodeNamedString(enc, pend, &av_audiocodecid, &av_mp4a);
    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_audiodatarate, self.conf.audioBitrate);

    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_audiosamplerate, self.conf.audioSampleRate);
    enc = PILI_AMF_EncodeNamedNumber(enc, pend, &av_audiosamplesize, 16.0);
    enc = PILI_AMF_EncodeNamedBoolean(enc, pend, &av_stereo, self.conf.numberOfChannels == 2);

    // sdk version
    enc = PILI_AMF_EncodeNamedString(enc, pend, &av_encoder, &av_SDKVersion);

    *enc++ = 0;
    *enc++ = 0;
    *enc++ = PILI_AMF_OBJECT_END;

    packet.m_nBodySize = (uint32_t)(enc - packet.m_body);
    if (!PILI_RTMP_SendPacket(_rtmp, &packet, FALSE, &_error)) {
        return;
    }
}

- (void)sendVideoHeaderWithSPS:(NSData *)spsData pps:(NSData *)ppsData {
    unsigned char *body = NULL;
    NSInteger iIndex = 0;
    NSInteger rtmpLength = 1024;
    const char *sps = spsData.bytes;
    const char *pps = ppsData.bytes;
    NSInteger sps_len = spsData.length;
    NSInteger pps_len = ppsData.length;

    body = (unsigned char *)malloc(rtmpLength);
    memset(body, 0, rtmpLength);

    body[iIndex++] = 0x17;
    body[iIndex++] = 0x00;

    body[iIndex++] = 0x00;
    body[iIndex++] = 0x00;
    body[iIndex++] = 0x00;

    body[iIndex++] = 0x01;
    body[iIndex++] = sps[1];
    body[iIndex++] = sps[2];
    body[iIndex++] = sps[3];
    body[iIndex++] = 0xff;

    /*sps*/
    body[iIndex++] = 0xe1;
    body[iIndex++] = (sps_len >> 8) & 0xff;
    body[iIndex++] = sps_len & 0xff;
    memcpy(&body[iIndex], sps, sps_len);
    iIndex += sps_len;

    /*pps*/
    body[iIndex++] = 0x01;
    body[iIndex++] = (pps_len >> 8) & 0xff;
    body[iIndex++] = (pps_len) & 0xff;
    memcpy(&body[iIndex], pps, pps_len);
    iIndex += pps_len;

    [self sendPacket:RTMP_PACKET_TYPE_VIDEO data:body size:iIndex nTimestamp:0];
    free(body);
}

- (void)sendVideoWithVideoData:(NSData *)frameData timestamp:(uint64_t)timestamp isKeyFrame:(BOOL)isKeyFrame {
    NSInteger i = 0;
    NSInteger rtmpLength = frameData.length + 9;
    unsigned char *body = (unsigned char *)malloc(rtmpLength);
    memset(body, 0, rtmpLength);

    if (isKeyFrame) {
        body[i++] = 0x17;        // 1:Iframe  7:AVC
    } else {
        body[i++] = 0x27;        // 2:Pframe  7:AVC
    }
    body[i++] = 0x01;    // AVC NALU
    body[i++] = 0x00;
    body[i++] = 0x00;
    body[i++] = 0x00;
    body[i++] = (frameData.length >> 24) & 0xff;
    body[i++] = (frameData.length >> 16) & 0xff;
    body[i++] = (frameData.length >>  8) & 0xff;
    body[i++] = (frameData.length) & 0xff;
    memcpy(&body[i], frameData.bytes, frameData.length);

    [self sendPacket:RTMP_PACKET_TYPE_VIDEO data:body size:(rtmpLength) nTimestamp:timestamp];
    free(body);
}

- (NSInteger)sendPacket:(unsigned int)nPacketType data:(unsigned char *)data size:(NSInteger)size nTimestamp:(uint64_t)nTimestamp {
    NSInteger rtmpLength = size;
    PILI_RTMPPacket rtmp_pack;
    PILI_RTMPPacket_Reset(&rtmp_pack);
    PILI_RTMPPacket_Alloc(&rtmp_pack, (uint32_t)rtmpLength);

    rtmp_pack.m_nBodySize = (uint32_t)size;
    memcpy(rtmp_pack.m_body, data, size);
    rtmp_pack.m_hasAbsTimestamp = 0;
    rtmp_pack.m_packetType = nPacketType;
    if (_rtmp) rtmp_pack.m_nInfoField2 = _rtmp->m_stream_id;
    rtmp_pack.m_nChannel = 0x04;
    rtmp_pack.m_headerType = RTMP_PACKET_SIZE_LARGE;
    if (RTMP_PACKET_TYPE_AUDIO == nPacketType && size != 4) {
        rtmp_pack.m_headerType = RTMP_PACKET_SIZE_MEDIUM;
    }
    rtmp_pack.m_nTimeStamp = (uint32_t)nTimestamp;

    NSInteger nRet = [self RtmpPacketSend:&rtmp_pack];

    PILI_RTMPPacket_Free(&rtmp_pack);
    return nRet;
}

- (NSInteger)RtmpPacketSend:(PILI_RTMPPacket *)packet {
    if (_rtmp && PILI_RTMP_IsConnected(_rtmp)) {
        int success = PILI_RTMP_SendPacket(_rtmp, packet, 0, &_error);
        return success;
    }
    return -1;
}

- (void)sendAudioHeader:(NSData *)header {
    NSInteger rtmpLength = header.length + 2;     /*spec data长度,一般是2*/
    unsigned char *body = (unsigned char *)malloc(rtmpLength);
    memset(body, 0, rtmpLength);

    /*AF 00 + AAC RAW data*/
    body[0] = 0xAF;
    body[1] = 0x00;
    memcpy(&body[2], header.bytes, header.length);          /*spec_buf是AAC sequence header数据*/
    [self sendPacket:RTMP_PACKET_TYPE_AUDIO data:body size:rtmpLength nTimestamp:0];
    free(body);
}

- (void)sendAudioWithAudioData:(NSData *)audioData timestamp:(uint64_t)timestamp {
    NSInteger rtmpLength = audioData.length + 2;    /*spec data长度,一般是2*/
    unsigned char *body = (unsigned char *)malloc(rtmpLength);
    memset(body, 0, rtmpLength);

    /*AF 01 + AAC RAW data*/
    body[0] = 0xAF;
    body[1] = 0x01;
    memcpy(&body[2], audioData.bytes, audioData.length);
    [self sendPacket:RTMP_PACKET_TYPE_AUDIO data:body size:rtmpLength nTimestamp:timestamp];
    free(body);
}



#pragma mark -- CallBack
void RTMPErrorCallback(RTMPError *rtmpError, void *userData) {
    // not error
    if(rtmpError->code >= 0) {
        return;
    }
    HPRTMP *rtmp = (__bridge HPRTMP *)userData;
    if (rtmp.delegate && [rtmp.delegate respondsToSelector:@selector(rtmp:error:)]) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
       if(rtmpError->message != nil) {
            NSString *msg = [NSString stringWithUTF8String:rtmpError->message];
            [details setValue:msg forKey:NSLocalizedDescriptionKey];
        }
        NSError *error = [[NSError alloc] initWithDomain:@"com.huiping192.HPRTMP.error" code:rtmpError->code userInfo:details];
        [rtmp.delegate rtmp:rtmp error:error];
    }
}

void ConnectionTimeCallback(PILI_CONNECTION_TIME *conn_time, void *userData) {
}

@end
