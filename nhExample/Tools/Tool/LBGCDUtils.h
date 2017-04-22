//
//  LBGCDUtils.h
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 封装GCD 的工具类
 */
@interface LBGCDUtils : NSObject


/**
 * 封装了一个定时器执行任务
 @param totalTime 总的执行时间
 @param offsetTime 时间间隔
 @param queue 执行的线程
 @param block 执行的任务
 */
+(void)GCDTimer:(CGFloat)totalTime offsetTime:(CGFloat)offsetTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block;


/**
 * 延迟执行的任务
 @param afterTime 延迟的时间
 @param block 执行的任务
 */
+(void)GCDAfterTime:(CGFloat)afterTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block;

/**
 * 返回一个定时器timer  可以用来取消
 @param intervalTime 执行的时间间隔
 @param queue queue
 @param block 执行的任务
 @return 定时器
 */
+(dispatch_source_t)GCDInterValTimer:(CGFloat)intervalTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block;
@end
