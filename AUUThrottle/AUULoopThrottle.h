//
//  AUULoopThrottle.h
//  AUUThrottle
//
//  Created by JyHu on 2017/5/30.
//
//

#import <Foundation/Foundation.h>

@class AUULoopThrottle;

@protocol AUULoopThrottleDelegate <NSObject>

@optional

/**
 初始化
 */
- (void)initlization:(AUULoopThrottle *)throttle;

/**
 轮询执行的代理方法
 */
- (void)loopExecution:(AUULoopThrottle *)throttle;

@end

typedef void (^AUULoopHandleBlock)(AUULoopThrottle *loopThrottle);

@interface AUULoopThrottle : NSObject <AUULoopThrottleDelegate>

/**
 初始化方法

 @param target 持有者
 @param delegate 轮询方法的代理
 @return self
 */
+ (instancetype)throttleWithTarget:(id)target delay:(NSTimeInterval)delay delegate:(id <AUULoopThrottleDelegate>)delegate;
+ (instancetype)throttleWithTarget:(id)target delay:(NSTimeInterval)delay;

@property (weak, nonatomic, readonly) id target;
@property (assign, nonatomic, readonly) NSTimeInterval delay;

/**
 是否还在循环中
 */
@property (assign, nonatomic, readonly) BOOL isOpen;

/**
 循环的次数
 */
@property (assign, nonatomic, readonly) NSUInteger loopCount;

/**
 轮询要执行的方法
 */
@property (assign, nonatomic) SEL handleSelector;

/**
 是否在开始的时候就执行
 如果为yes，则在resume开始的时候就会开始执行轮询的方法
 如果为no，则会在 delay 时间之后开始执行轮询的方法
 */
@property (assign, nonatomic) BOOL executeAtStart;

/**
 是否在暂停的时候重新开始统计轮询次数
 */
@property (assign, nonatomic) BOOL resetCounterWhenPause;

/**
 轮询要执行的block
 */
@property (copy, nonatomic) AUULoopHandleBlock loopHandleBlock;

/**
 开始轮询
 */
- (void)resume;

/**
 暂停轮询
 */
- (void)pause;

/**
 取消循环，在不用了以后一定要注意取消
 */
- (void)invalidate;

@end
