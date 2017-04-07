//
//  LBSDImageCache.h
//  LBSamples
//
//  Created by liubin on 17/2/28.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 封装图片缓存的接口  剥离第三方框架
 */
@interface LBSDImageCache : NSObject

/**
  根据图片路径在缓存中查找图片

 @param imageUrl imageUrl
 @return 查找到的图片
 */
+(UIImage *)imageFromDiskCacheForKey:(NSString *)imageUrl;



/**
 下载图片 用url、缓存路径

 @param imageUrl 图片的url
 @param progress 下载进度
 @param completed 完成的回调
 */
+(void)downLoadImageWithUrl:(NSString *)imageUrl progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress completed:(void (^)(UIImage *image, NSData *data, NSError *error, BOOL finished))completed;
single_interface(LBSDImageCache)
@end
