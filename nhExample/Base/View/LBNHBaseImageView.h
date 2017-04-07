//
//  LBNHBaseImageView.h
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//


/**
 图片的进度  0-1
 */
typedef void(^ImageProgressHandler)(CGFloat progress);

#import <UIKit/UIKit.h>


/**
 网络基础类的imageView
 */
@interface LBNHBaseImageView : UIImageView


/**
 设置图片
 */
-(void)setImagePath:(NSString *)imagePath;
-(void)setImageURL:(NSURL *)imageURL;


/**
 设置图片   带占位图的
 */
-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image;
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image;


/**
 设置图片 带占位图的  带结束回调的
 */
-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image finishHandler:(void(^)(NSError *error, UIImage *image))finishHandler;
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image finishHandler:(void(^)(NSError *error, UIImage *image))finishHandler;


/**
 
设置图片 带占位图的  带进度的 带结束回调的
 */
-(void)setImagePath:(NSString *)imagePath placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError * error, UIImage *image))finishHandler;
-(void)setImageURL:(NSURL *)imageURL placeHolder:(UIImage *)image progressHandler:(ImageProgressHandler)progressHandler finishHandler:(void (^)(NSError *error, UIImage *image))finishHandler;


@end
