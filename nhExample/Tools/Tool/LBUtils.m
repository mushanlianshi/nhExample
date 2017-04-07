//
//  LBUtils.m
//  nhExample
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBUtils.h"
#import "LBNHUserInfoManager.h"
#import "LBNHUserInfoModel.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

@implementation LBUtils

+(BOOL)isCurrentLoginUserInfo:(NSInteger)userID{
    if (userID == 0) return NO;
    if (![[LBNHUserInfoManager sharedLBNHUserInfoManager] isLogin]) {
        return NO;
    }
    LBNHUserInfoModel *useInfo=[[LBNHUserInfoManager sharedLBNHUserInfoManager] currentLoginUserInfo];
    return (useInfo.user_id == userID);
}

+(void)forBiddenSDWebImageDecode:(BOOL)isForbidden{
    SDImageCache *cache = [SDImageCache sharedImageCache];
    SDWebImageDownloader *downLoader = [SDWebImageDownloader sharedDownloader];
//    cache.shouldDecompressImages = !isForbidden;
    downLoader.shouldDecompressImages = !isForbidden;
}

/** 根据格式化字符串 时间戳转时间 */
+(NSString *)convertTime:(NSTimeInterval)time WithFormatterString:(NSString *)formatterString{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterString;
    NSString *result = [formatter stringFromDate:date];
    return result;
}

/** 把时间戳转成几天 几分钟 刚刚的方法 */
+(NSString *)converTimeToMinutesAgo:(NSTimeInterval)time{
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval offsetTime = currentTimeInterval - time;
    if (offsetTime < 60) {
        return @"刚刚";
    }
    NSInteger minutes = offsetTime/60;
    if (minutes < 60){
        return [NSString stringWithFormat:@"%ld分钟前",minutes];
    }
    NSInteger hours = offsetTime/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    NSInteger days = offsetTime/3600/24;
    if (days<30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    NSInteger months = offsetTime/3400/24/30;
    if (months<12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    NSInteger years = offsetTime/3400/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

// 获取当前设备可用内存(单位：MB）
+ (NSInteger )availableMemory
{
    NSDictionary *folderAttr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *freeSpace = [folderAttr objectForKey:NSFileSystemFreeSize];
    long long longnum = freeSpace.longLongValue;
    longnum = longnum/(1024*1024)-200;
    return (NSInteger)longnum;
}

// 获取总内存（单位：MB）
+ (NSInteger)totalMemory
{
    NSDictionary *folderAttr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *totalSpace = [folderAttr objectForKey:NSFileSystemSize];
    long long longnum = totalSpace.longLongValue;
    longnum = longnum/(1024*1024);
    return (NSInteger)longnum;
    
}

+ (UIImage *)screenshot
{
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        //函数的作用是将当前图形状态推入堆栈
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
