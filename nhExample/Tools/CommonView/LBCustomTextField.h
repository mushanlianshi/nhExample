//
//  LBCustomTextField.h
//  nhExample
//
//  Created by liubin on 17/4/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 自定义的textField
 */
@interface LBCustomTextField : UITextField

/**
 * 初始化textField
 @param frame 位置frame
 @param pleaceHolder 提示的字
 @param holderColor  提示字体的颜色
 @param textColor 输入字体的颜色
 @param leftImage 左边显示的图片
 @param rightImage 右边显示的图片
 @param leftMargin 左边显示的距离
 */
-(instancetype)initWithFrame:(CGRect)frame pleaceHolder:(NSString *)pleaceHolder pleaceHolderColor:(UIColor *)holderColor textColor:(UIColor *)textColor leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage leftMargin:(CGFloat)leftMargin;


/**
 *
 * 是否显示右边的图片
 */
-(void)showRightImageView:(BOOL)isShow;

@property (nonatomic, strong) UIColor *pleaceHolderColor;

@end
