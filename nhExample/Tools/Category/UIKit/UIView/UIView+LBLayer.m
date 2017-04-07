//
//  UIView+LBLayer.m
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "UIView+LBLayer.h"

@implementation UIView (LBLayer)

-(void)setLayerBorderColor:(UIColor *)layerBorderColor{
    self.layer.borderColor = layerBorderColor.CGColor;
    [self _config];
}
-(void)setLayerBorderWidth:(CGFloat)layerBorderWidth{
    self.layer.borderWidth = layerBorderWidth;
    [self _config];
}
-(void)setLayerCornerRadius:(CGFloat)layerCornerRadius{
    self.layer.cornerRadius = layerCornerRadius;
    [self _config];
}
-(UIColor *)layerBorderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(CGFloat)layerBorderWidth{
    return self.layer.borderWidth;
}

-(CGFloat)layerCornerRadius{
    return self.layer.cornerRadius;
}

-(void)setLayerCornerRadius:(CGFloat)layerCornerRadius borderWitdh:(CGFloat)borderWitdh borderColor:(UIColor *)borderColor{
    self.layer.cornerRadius = layerCornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWitdh;
    [self _config];
}


- (void)_config {
    
    self.layer.masksToBounds = YES;
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}
@end
