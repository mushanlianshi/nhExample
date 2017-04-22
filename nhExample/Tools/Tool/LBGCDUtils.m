//
//  LBGCDUtils.m
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBGCDUtils.h"

@implementation LBGCDUtils
+(void)GCDTimer:(CGFloat)totalTime offsetTime:(CGFloat)offsetTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block{
    queue = queue ? queue : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, offsetTime * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __block NSTimeInterval offsetT = 0;
    dispatch_source_set_event_handler(timer, ^{
        if (offsetT>=totalTime) {
            dispatch_source_cancel(timer);
        }else{
            if (block) {
                block();
            }
            offsetT +=offsetTime;
        }
    });
    dispatch_resume(timer);
}

+(void)GCDAfterTime:(CGFloat)afterTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block{
    queue = queue ? queue : dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), queue, ^{
        if (block) {
            block();
        }
    });
}

+(dispatch_source_t)GCDInterValTimer:(CGFloat)intervalTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block{
    queue = queue ? queue : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, intervalTime * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (block) {
            block();
        }
    });
    dispatch_resume(timer);
    return timer;
}
@end
