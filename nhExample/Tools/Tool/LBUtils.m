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
#import <AdSupport/AdSupport.h>

#define kLastLaunchAPPTime @"kLastLaunchAPPTime"

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


+(NSAttributedString *)attributeWithString:(NSString *)string keyWords:(NSString *)keyWords font:(UIFont *)font highLightColor:(UIColor *)highLightColor textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace{
    if (string.length) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange keyRange = [string rangeOfString:keyWords];
        //1.没有关键字  只处理设置的属性
        if (!keyWords || keyWords.length == 0 || keyRange.location == NSNotFound) {
            NSRange allRange = [string rangeOfString:string];
            [attributeString addAttribute:NSForegroundColorAttributeName value:textColor range:allRange];
            [attributeString addAttribute:NSFontAttributeName value:font range:allRange];
            
            //行间距的属性
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = lineSpace;
            [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:allRange];
            return attributeString.copy;
        }else{
            NSRange allRange = NSMakeRange(0, string.length);
            [attributeString addAttribute:NSFontAttributeName value:font range:allRange];
            [attributeString addAttribute:NSForegroundColorAttributeName value:textColor range:allRange];
            [attributeString addAttribute:NSForegroundColorAttributeName value:highLightColor range:keyRange];
            
            //间距的属性
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = lineSpace;

            [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:allRange];
            return attributeString.copy;
        }
        
    }
    return [[NSAttributedString alloc] init];
}


/**
 * 获取广告标示
 @return 广告标示
 */
+ (NSString *)idfa{
    NSUUID *uuid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    return [uuid UUIDString];
}


/**
 * 替代UDID的 同一个设备 同一个应用的idfv是一样的
 */
+ (NSString *)idfv{
    NSUUID *uuid= [[UIDevice currentDevice] identifierForVendor];
    return [uuid UUIDString];
}

+(NSString *)uuid{
    return [NSUUID UUID].UUIDString;
}

+(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.f, 0.f, 1.0f, 1.0f);
    //已多大的尺寸开始一个上下文
    UIGraphicsBeginImageContext(rect.size);
    //获取一个图片上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置填充的颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    //设置填充的区域
    CGContextFillRect(context, rect);
    //从上下文中获取一个图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束处理图片的上下文
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] == NO) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        　　　　　//SDWebImage框架自身计算缓存的实现
        CGFloat sdCache = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        folderSize+=sdCache;
        return folderSize;
    }
    return 0;
}

+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

/** 每次启动调用保存app启动时间的方法 用来判断两次启动时间间隔的 */
+(void)saveLastLaunchAPPTime{
    NSDate *nowDate = [NSDate date];
    long nowTime = [nowDate timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:nowTime] forKey:kLastLaunchAPPTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 获取上次启动app的时间  距离1970 */
+(long)lastLaunchAPPTime{
    long lastTime = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastLaunchAPPTime] longValue];
    return lastTime;
}

/** 获取两次启动的时间差 */
+(long)lastLauchAPPToNow{
    long lastTime = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastLaunchAPPTime] longValue];
    NSDate *nowDate = [NSDate date];
    long nowTime = [nowDate timeIntervalSince1970];
    return  labs(nowTime - lastTime);
}

@end
