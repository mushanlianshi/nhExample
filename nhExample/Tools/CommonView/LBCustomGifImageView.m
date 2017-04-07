//
//  LBCustomGifImageView.m
//  nhExample
//
//  Created by liubin on 17/3/23.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomGifImageView.h"

@interface LBCustomGifImageView()


/** 显示进度的layer */
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation LBCustomGifImageView



/** 设置进度 设置layer的宽度 */
-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (_progress == 1) {
        [self.progressLayer removeFromSuperlayer];
        _progressLayer = nil;
        return;
    }else{
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width*progress, 3)];
        self.progressLayer.path = path.CGPath;
    }
}


-(CAShapeLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [[CAShapeLayer alloc] init];
        //设置填充颜色
        _progressLayer.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.8].CGColor;
        [self.layer addSublayer:_progressLayer];
    }
    return _progressLayer;
}

@end
