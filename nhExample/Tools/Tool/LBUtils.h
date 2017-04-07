//
//  LBUtils.h
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBUtils : NSObject


/**
 * 判断是否是当前登录的用户
 */
+(BOOL)isCurrentLoginUserInfo:(NSInteger)userID;


/**
 * 禁止SDwebImage解压缩图片 高清图片解压缩会相当消耗内存  小图片解压缩
 */
+(void)forBiddenSDWebImageDecode:(BOOL)isForbidden;



#pragma mark 时间格式化相关的
/** 根据格式化字符串 时间戳转时间 */
+(NSString *)convertTime:(NSTimeInterval)time WithFormatterString:(NSString *)formatterString;

/** 把时间戳转成几天 几分钟 刚刚的方法 */
+(NSString *)converTimeToMinutesAgo:(NSTimeInterval)time;

// 获取当前设备可用内存(单位：MB）
+ (NSInteger )availableMemory;

// 获取总内存（单位：MB）
+ (NSInteger)totalMemory;

/** 截屏 */
+ (UIImage *)screenshot;

@end
