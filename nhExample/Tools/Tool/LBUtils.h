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


/**
 * 获取一个富文本
 @param string 总文字
 @param keyWords 需要高亮的文字
 @param font 默认字体大小
 @param highLightColor 高亮的颜色
 @param textColor 默认的颜色
 @param lineSpace 字间距
 */
+ (NSAttributedString *)attributeWithString:(NSString *)string keyWords:(NSString *)keyWords font:(UIFont *)font highLightColor:(UIColor *)highLightColor textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace;


/**
 * 获取广告标示
 @return 广告标示
 */
+ (NSString *)idfa;


/**
 * 替代UDID的 同一个设备 同一个应用的idfv是一样的
 */
+ (NSString *)idfv;

//,翻译过来就是通用唯一标识符。是一个32位的十六进制序列  每秒都不一样的
+ (NSString *)uuid;

/**
 * 颜色转成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)string;

/** 获取某路径下文件的大小 */
+(float)folderSizeAtPath:(NSString *)path;

/** 清楚某路径下的文件 */
+(void)clearCache:(NSString *)path;

/** 每次启动调用保存app启动时间的方法 用来判断两次启动时间间隔的 */
+(void)saveLastLaunchAPPTime;

/** 获取上次启动app的时间  距离1970 */
+(long)lastLaunchAPPTime;

/** 获取两次启动的时间差 */
+(long)lastLauchAPPToNow;

@end
