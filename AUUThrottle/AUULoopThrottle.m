//
//  AUULoopThrottle.m
//  AUUThrottle
//
//  Created by JyHu on 2017/5/30.
//
//

#import "AUULoopThrottle.h"
#import "NSTimer+AUUThrottle.h"

@interface AUULoopThrottle ()

@property (retain, nonatomic) NSTimer *pri_throttleTimer;

@property (weak, nonatomic) id pri_target;

/**
 轮询的次数
 */
@property (assign, nonatomic) NSUInteger pri_loopCount;

/**
 轮询的时间间隔
 */
@property (assign, nonatomic) NSTimeInterval pri_delay;

@property (assign, nonatomic) id<AUULoopThrottleDelegate> pri_delegate;

@end

@implementation AUULoopThrottle

+ (instancetype)throttleWithTarget:(id)target delay:(NSTimeInterval)delay
{
    return [self throttleWithTarget:target delay:delay delegate:nil];
}

+ (instancetype)throttleWithTarget:(id)target delay:(NSTimeInterval)delay delegate:(id<AUULoopThrottleDelegate>)delegate
{
    AUULoopThrottle *throttle = [[self alloc] init];
    throttle.executeAtStart = YES;
    throttle.resetCounterWhenPause = YES;
    throttle.pri_delay = delay;
    throttle.pri_target = target;
    throttle.pri_loopCount = 0;
    throttle.pri_delegate = delegate ?: throttle;
    
    if ([throttle.pri_delegate respondsToSelector:@selector(initlization:)]) {
        [throttle.pri_delegate initlization:throttle];
    }
    
    return throttle;
}

- (void)resume {
    if (self.resetCounterWhenPause) {
        self.pri_loopCount = 0;
    }
    
    if (!self.pri_throttleTimer) {
        __weak AUULoopThrottle *weakSelf = self;
        void (^timerBlock)(NSTimer *timer) = ^(NSTimer *timer) {
            __strong AUULoopThrottle *strongSelf = weakSelf;
            
            strongSelf.pri_loopCount ++;
            
            if (strongSelf.pri_delegate && [strongSelf.pri_delegate respondsToSelector:@selector(loopExecution:)]) {
                [strongSelf.pri_delegate loopExecution:strongSelf];
            }
            
            if (strongSelf.handleSelector && strongSelf.pri_target && [strongSelf.pri_target respondsToSelector:strongSelf.handleSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [strongSelf.pri_target performSelector:strongSelf.handleSelector withObject:strongSelf];
#pragma clang diagnostic pop
            }
            if (strongSelf.loopHandleBlock) {
                strongSelf.loopHandleBlock(strongSelf);
            }
        };
        
        NSDate *executeDate = [NSDate date];
        if (!self.executeAtStart) {
            executeDate = [executeDate dateByAddingTimeInterval:self.pri_delay];
        }
        self.pri_throttleTimer = [NSTimer auu_scheduledWithFireDate:executeDate timeInterval:self.pri_delay repeats:YES block:timerBlock];
        
        [[NSRunLoop currentRunLoop] addTimer:self.pri_throttleTimer forMode:NSDefaultRunLoopMode];
    }
    
    if (!self.pri_throttleTimer.isOpen) {
        if (self.executeAtStart) {
            [self.pri_throttleTimer auu_resume];
        } else {
            [self.pri_throttleTimer auu_resumeWithDelay:self.pri_delay];
        }
    }
}

- (void)pause {
    if (self.pri_throttleTimer) {
        [self.pri_throttleTimer auu_pause];
    }
}

- (void)invalidate {
    if (self.pri_throttleTimer) {
        [self.pri_throttleTimer invalidate];
        self.pri_throttleTimer = nil;
    }
}

- (BOOL)isOpen {
    return self.pri_throttleTimer ? self.pri_throttleTimer.isOpen : NO;
}

- (NSUInteger)loopCount {
    return self.pri_loopCount;
}

- (id)target {
    return self.pri_target;
}

- (NSTimeInterval)delay {
    return self.pri_delay;
}

@end
