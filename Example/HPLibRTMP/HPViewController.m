//
//  HPViewController.m
//  HPLibRTMP
//
//  Created by huiping_guo on 03/29/2020.
//  Copyright (c) 2020 huiping_guo. All rights reserved.
//

#import "HPViewController.h"
#import "HPRTMP.h"
#import <AVFoundation/AVFoundation.h>

NSString const* kRTMP = @"rtmp://10.0.1.14/live?key=huiping";
NSString const* kSourceMP4 = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";

@interface HPViewController ()
 
@property(nonatomic,retain) HPRTMP *rtmp;
 
@end

@implementation HPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.rtmp = [[HPRTMP alloc] initWithRTMPURL:kRTMP];
}

//-(void)test {
//    AVAsset *set = [AVAsset assetWithURL:url];
//
//        AVAssetReader *assetReader = [[AVAssetReader alloc] initWithAsset:set error:nil];
//
//        NSArray *videoTracks = [set tracksWithMediaType:AVMediaTypeVideo];
//        // Decompression settings for ARGB.
//        NSDictionary *decompressionVideoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32ARGB], (id)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary] };
//
//    //    self.trackOutput = AVAssetReaderTrackOutput(track: tracks[0] as AVAssetTrack, outputSettings: outputSetting)
//
//        AVAssetReaderTrackOutput *output = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTracks[0] outputSettings:decompressionVideoSettings];
//
//        if ([assetReader canAddOutput:output]) {
//            [assetReader addOutput:output];
//        }
//
//        [assetReader startReading];
//
//        BOOL done = NO;
//        while (!done) {
//            // Copy the next sample buffer from the reader output.
//            CMSampleBufferRef sampleBuffer = [output copyNextSampleBuffer];
//            if (sampleBuffer) {
//                // Do something with sampleBuffer here.
//
//                [self.rtmp sendVideoWithVideoData:<#(NSData *)#> timestamp:CMSampleBufferGetPresentationTimeStamp(sampleBuffer) isKeyFrame:isKeyFrame(sampleBuffer)]
//
//                CFRelease(sampleBuffer);
//                sampleBuffer = NULL;
//            } else{
//                // The asset reader output has read all of its samples.
//                done = YES;
//            }
//        }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
