//
//  NSTimer+AUUThrottle.h
//  AUUThrottle
//
//  Created by JyHu on 2017/5/30.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (AUUThrottle)

@property (assign, nonatomic, getter=isOpen) BOOL open;

- (void)auu_pause;
- (void)auu_resume;
- (void)auu_resumeWithDelay:(NSTimeInterval)delay;

+ (NSTimer *_Nullable)auu_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                                 repeats:(BOOL)repeats
                                                   block:(void (^_Nullable)(NSTimer * _Nonnull timer))block;
+ (NSTimer *_Nullable)auu_scheduledWithFireDate:(NSDate *_Nullable)date
                                   timeInterval:(NSTimeInterval)interval
                                        repeats:(BOOL)repeats
                                          block:(void (^_Nullable)(NSTimer * _Nonnull timer))block;


@end
