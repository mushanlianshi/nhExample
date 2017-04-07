//
//  UIView+LBLayer.h
//  nhExample
//
//  Created by liubin on 17/3/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 设置viewlayer的一些属性
 */
@interface UIView (LBLayer)

/**
 layer 的border的宽度  边线宽度
 */
@property (nonatomic, assign) CGFloat layerBorderWidth;

/**
 layer 的cornerRaduis  边角半径
 */
@property (nonatomic, assign) CGFloat layerCornerRadius;


/**
 layer 的border的颜色 边线颜色
 */
@property (nonatomic, strong) UIColor *layerBorderColor;


-(void)setLayerCornerRadius:(CGFloat)layerCornerRadius borderWitdh:(CGFloat)borderWitdh borderColor:(UIColor *)borderColor;
@end
