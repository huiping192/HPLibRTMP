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

@end
