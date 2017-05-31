//
//  NSTimer+AUUThrottle.m
//  AUUThrottle
//
//  Created by JyHu on 2017/5/30.
//
//

#import "NSTimer+AUUThrottle.h"
#import <objc/runtime.h>

@implementation NSTimer (AUUThrottle)

const char *__AUUTimerOpeningAssociatedKey = (void *)@"com.auu.__AUUTimerOpeningAssociatedKey";

- (void)setOpen:(BOOL)open {
    objc_setAssociatedObject(self, __AUUTimerOpeningAssociatedKey, @(open), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isOpen {
    return [objc_getAssociatedObject(self, __AUUTimerOpeningAssociatedKey) boolValue];
}

- (void)auu_pause {
    if (self.isValid) {
        [self setFireDate:[NSDate distantFuture]];
        self.open = NO;
    }
}

- (void)auu_resume {
    if (self.isValid) {
        self.open = YES;
        [self setFireDate:[NSDate date]];
    }
}

- (void)auu_resumeWithDelay:(NSTimeInterval)delay {
    if (self.isValid) {
        self.open = YES;
        [self setFireDate:[[NSDate date] dateByAddingTimeInterval:delay]];
    }
}

+ (NSTimer *)auu_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(auu_blockInvoke:) userInfo:[block copy] repeats:YES];
}

+ (NSTimer *)auu_scheduledWithFireDate:(NSDate *)date timeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block {
    return [[NSTimer alloc] initWithFireDate:date interval:interval target:self selector:@selector(auu_blockInvoke:) userInfo:[block copy] repeats:YES];
}

+ (void)auu_blockInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *timer) =timer.userInfo;
    if (block && timer.isValid) {
        block(timer);
    }
}


@end
