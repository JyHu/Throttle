//
//  AUULoopThrottle+Helper.m
//  AUUThrottle
//
//  Created by JyHu on 2017/5/31.
//
//

#import "AUULoopThrottle+Helper.h"

@implementation AUULoopThrottle (Helper)

- (void)initlization:(AUULoopThrottle *)throttle
{
    NSLog(@"initlization with target %@", throttle.target);
}

- (void)loopExecution:(AUULoopThrottle *)throttle
{
    throttle.resetCounterWhenPause = YES;
    if (throttle.loopCount == 5) {
        [throttle pause];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [throttle resume];
        });
    }
}

@end
