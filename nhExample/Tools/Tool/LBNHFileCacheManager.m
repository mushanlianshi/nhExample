//
//  LBNHFileCacheManager.m
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHFileCacheManager.h"
#import "NSFileManager+LBPath.h"

@implementation LBNHFileCacheManager
#pragma mark 归解档方法
+(BOOL)saveObjcet:(id)object byFileName:(NSString *)fileName{
    NSString *path = [self appendFilePath:fileName];
    path = [path stringByAppendingString:@".archive"];
    //开始归档
    BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:path];
    return success;
}

+(id)getObjectByFileName:(NSString *)fileName{
    NSString *path = [self appendFilePath:fileName];
    path = [path stringByAppendingString:@".archive"];
    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return  object;
}


+(void)removeObjectByFileName:(NSString *)fileName{
    NSString *path = [self appendFilePath:fileName];
    path = [path stringByAppendingString:@".archive"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/**
 根据文件名  获取缓存的路径
 */
+(NSString *)appendFilePath:(NSString *)fileName{
    NSString *cachePath = [NSFileManager cachesPath];
    cachePath=[cachePath stringByAppendingPathComponent:fileName];
    //如果文件不存在  我们创建路径 用来保存文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return cachePath;
}


/**
 * NSUserDefault 保存信息
 */
+(void)saveUserData:(id)object forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    //立即保存
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * NSUserDefault 获取保存的值
 */
+(id)readUserDataForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


@end
